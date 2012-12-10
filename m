Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab2LJMzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 07:55:44 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47809 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2LJMzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 07:55:42 -0500
MIME-Version: 1.0
In-Reply-To: <50C5B7E3.2080909@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
	<1354723742-6195-4-git-send-email-james.hogan@imgtec.com>
	<50C2B751.5000507@zytor.com>
	<50C5B7E3.2080909@imgtec.com>
Date: Mon, 10 Dec 2012 13:55:39 +0100
X-Google-Sender-Auth: ZrV3iCOW28HqTAXCsnH2FLaJw7E
Message-ID: <CAMuHMdXpw+hWgcqDiFVdDTsFBEThjvB_Y0jcoZZHS-JGTBvYRg@mail.gmail.com>
Subject: Re: [PATCH v2 03/44] Add CONFIG_HAVE_64BIT_ALIGNED_STRUCT for taskstats
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Balbir Singh <bsingharora@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, Will Drewry <wad@chromium.org>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 11:22 AM, James Hogan <james.hogan@imgtec.com> wrote:
> On 08/12/12 03:43, H. Peter Anvin wrote:
>> On 12/05/2012 08:08 AM, James Hogan wrote:
>>> On 64 bit architectures with no efficient unaligned access, taskstats
>>> has to add some padding to a reply to prevent unaligned access warnings.
>>> However this also needs to apply to 32 bit architectures with 64 bit
>>> struct alignment such as metag (which has 64 bit memory accesses).
>>
>> Wait... 64-bit struct alignment on structures with only 32-bit members?
>>  That might be... interesting... in a number of places...
>
> I'll rewrite the description as it's a bit misleading. On metag 64bit
> struct alignment is required when it contains 64bit members, not if it
> only contains 32bit members. Although metag is a 32bit arch, it can do
> 64bit memory accesses which must be aligned.

The C alignment rules should take care of this automatically (struct alignment
is the maximum alignment of its members).

You only have to override this manually in cases like this, where
64-bit quantities
are stored in char arrays:

 struct buffer_data_page {
        u64              time_stamp;    /* page time stamp */
        local_t          commit;        /* write committed index */
-       unsigned char    data[];        /* data of buffer page */
+       unsigned char    data[] RB_ALIGN_DATA;  /* data of buffer page */
 };

(cfr. your other patch).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
