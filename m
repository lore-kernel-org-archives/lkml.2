Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab1CCOoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:44:17 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33111 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758391Ab1CCOoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:44:16 -0500
MIME-Version: 1.0
In-Reply-To: <20110303141113.GF25891@n2100.arm.linux.org.uk>
References: <1298939263-16421-1-git-send-email-sjg@chromium.org>
	<20110301084949.GA16733@n2100.arm.linux.org.uk>
	<20110301085911.GB16733@n2100.arm.linux.org.uk>
	<19820.47240.801312.507393@pilspetsen.it.uu.se>
	<20110301100306.GA18007@n2100.arm.linux.org.uk>
	<AANLkTinMnZAupxn7oYFhqkN1Y0OD-eyN=UeRpw96no9r@mail.gmail.com>
	<20110302105930.GA2363@arm.com>
	<20110303141113.GF25891@n2100.arm.linux.org.uk>
Date: Thu, 3 Mar 2011 14:44:15 +0000
Message-ID: <AANLkTikQurH0FiYTpH1Xi22y7So47JsXCaxBe3ujzZp5@mail.gmail.com>
Subject: Re: [RFC PATCH] ARM: Use generic BUG() handler
From: Dave Martin <dave.martin@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Simon Glass <sjg@chromium.org>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Alexander Shishkin <virtuoso@slind.org>,
        Mikael Pettersson <mikpe@it.uu.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joe Perches <joe@perches.com>, Will Deacon <Will.Deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 2:11 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Mar 02, 2011 at 10:59:50AM +0000, Dave Martin wrote:
>> +     asm volatile("1:\t" __bug_instr "\n"            q       \
>> +                  ".pushsection .rodata.str, \"a\"\n"        \
>> +                  "2:\t.asciz \"" #__file "\"\n"             \
>> +                  ".popsection\n"                            \
>
> Doesn't this mean we end up with multiple file names?

Hmmm, yes, you're right.

After a bit of digging in the documentation, I find that ELF supports
mergable string sections though, so

.pushsection .rodata.str, "aMS", 1
    .asciz __FILE__
.popsection

...actually looks like it ought to do the right thing: duplicate
strings in the section get merged during linking, even if there are
duplicates from a single object.

Simple experiments suggest that the linker does this right, even
merging distinct strings which share a common suffix.  Do we use this
elsewhere in the kernel?  It it's not already used, it could be a win
for any large, static string tables.

>
>> +                  ".pushsection __bug_table,\"a\"\n"         \
>> +                  "3:\t.word 1b, 2b\n"                       \
>> +                  "\t.hword " #__line ", 0\n"                \
>> +                  ".popsection"                              \
>> +     unreachable();                                          \
>> +} while (0)
>
> Second problem is that the above produces this:
>
>        1:      .word 0xec000000
> .pushsection .rodata.str, "a"
> 2:      .asciz "__FILE__"
> .popsection
> .pushsection __bug_table,"a"
> 3:      .word 1b, 2b
>        .hword __LINE__, 0
> .popsection
>
> which is clearly not what we want.

Indeed.  I did say I hadn't tested it :)

> Adding another level of indirection
> starts to get closer to what we desire:
>
>        1:      .word 0xec000000
> .pushsection .rodata.str, "a"
> 2:      .asciz ""t.c""
> .popsection
> .pushsection __bug_table,"a"
> 3:      .word 1b, 2b
>        .hword 19, 0
> .popsection
>
> but we're still ending up with multiple strings containing the filename,
> which is going to excessively bloat the kernel no end.
>

We'd need to remove the duplicate quotes, too.

For the .org <blah> + sizeof (struct bug_entry) problem, Will pointed
out that there's a BUILD_BUG_ON() macro which we could used to avoid
silently producing a bad build if the result of that sizeof isn't what
we expect.

So I still think it could work ... but it's a bit of an ugly hack I confess.

Cheers
---Dave
