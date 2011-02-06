Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1BFAUk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 19:20:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42993 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab1BFAUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 19:20:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aqBazGbsNf5WD1gg39EW01ah5xEYFYfuf8ju6H39HWOPbANL9nkobHRGrlRkX1ZQly
         SKxSnrODlOWgHanfJODBZkm64OdXZsgnFgp7NUekDTiWqkd7LRpf4TK1N8+4t9UUSHQf
         Rb78TXBpnTrJ9LEke8RhK4g8taEKfK4NX7/ms=
MIME-Version: 1.0
In-Reply-To: <1296949161.2349.839.camel@pasglop>
References: <AANLkTimBFBKJf0-TNRLr2hHNEehR2cnKPvx06=yyHGVj@mail.gmail.com>
	<1296852667.2349.804.camel@pasglop>
	<20110204.145508.59670453.davem@davemloft.net>
	<4D4D9882.107@googlemail.com>
	<1296949161.2349.839.camel@pasglop>
Date: Sun, 6 Feb 2011 00:20:36 +0000
Message-ID: <AANLkTinEH+WAEUoWNYKxz6oRk7HAATG1p7CXMAx8Ss-V@mail.gmail.com>
Subject: Re: Sun GEM PPC32 Bug?
From: Matt <jackdachef@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        geert@linux-m68k.org, "R. Herbst" <ruediger.herbst@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 5, 2011 at 11:39 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Sat, 2011-02-05 at 19:35 +0100, R. Herbst wrote:
>> > I think we're simply not resetting enough when the RX FIFO overflow
>> > happens.
>> >
>> > Just for fun I checked the OpenBSD GEM driver to see what they do.
>> > When an overflow occurs, they bump the statistic, record the current
>> > read and write fifo pointer registers, and schedule a watchdog timer
>> > for 400ms into the future.
>> >
>> > If the watchdog timer sees that the RX FIFO overflow bit is still set
>> > in the RX status register, and the RX FIFO read and write pointers
>> > have not changed, it resets the entire chip.
>> >
>> > We unconditionally reset the RX MAC when an overflow occurs, that may
>> > simply not be enough to unwedge this thing.
>
> Right. It would be quite easy for us to do the same thing. Interestingly
> enough, I have never observed this behaviour on any of my machines (a
> wide range of 32-bit and 64-bit Apple machines).
>
> Also, Apple's own driver does things differently. In case of overflow
> interrupt, it seems to only bump some statistics. However, it has a
> timeout if no packets have been received for a while (5 seconds) and the
> Rx fifo overflow bit is set. In that case, they restart the receiver
> (and the receiver only).
>
> Their sequence for restarting the receiver however is a tad different
> than ours (mostly slightly different ordering of things), it's hard to
> tell whether that's relevant or not, but some of the things do make
> sense, such as they stop the DMA before resetting the MAC and restart it
> after re-enabling the MAC.
>
> If I find some time tonight, else tomorrow, I'll whip up a couple of
> patches:
>
>  - One simpler re-arranging our Rx reset sequence and adding a test for
> the overflow bit at the end, printing out the results, etc...
>
>  - One that basically always reset the chip on overflow.
>
> From there we can decide what works and maybe add a bit of a timeout
> to the second approach if needed etc... but how often does that overflow
> happens in practice ?
>
> Cheers,
> Ben.
>
>
>

Well,

according to this post:
http://forums.gentoo.org/viewtopic-p-6565281.html#6565281

>Okay... Es muss ein Kernelproblem sein. Mit SFTP bekomme ich nur einen Datendurchsatz von ca. 40MBit hin. Da kommen dann die Probleme nicht vor.
>Mit FTP direkt habe ich einen Datendurchsatz von ca. 180MBit/s, dann rasseln wieder die Kernelmeldungen ohne Ende.

it doesn't appear when using sftp (only achieving 40 MBit/s
throughput), whereas kernel messages continuously seem to appear when
using FTP with a throughput of around 180 MBit/s


this also seems to apply to recent kernels (2.6.37-ish) according to
http://forums.gentoo.org/viewtopic-p-6564885.html#6564885

>Erstmal vielen dank für diesen Tipp. Leider hat auch das nichts an meinem Netzwerkproblem geämdert. Zieht das System immer noch bei Netzwerklast ins verderben. FREEZE.
>Werde jetzt mal einen uraltkernel probieren. Vielleicht hilft ja das. Früher ging das System ja mal sehr gut mit Linux.

I don't know what Ruediger exactly means with "freeze"

@Ruediger:

did I miss anything ?

does magic sysrq key still work for you ?



This remembers me of a similar problem I had with the sky2-driver and
the 88E8053 chipset, for several kernel-releases it seems to reset
itself fine now :)

Regards

Matt
