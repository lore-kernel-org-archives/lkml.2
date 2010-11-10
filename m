Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0KJUGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:06:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45831 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab0KJUG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:06:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=qsFF+OW/6LTWU+PHcEZA77e5BmRr1l4323uU/y1kUcgaW0+aj6GKSyMKIDdNLZpedn
         a8rWdEqTUFk4mi3b2k2kl8hVZSY/MAGsazoxYH9LdDH4TTRhrjvJw9pUHAdihvg3H+1k
         oeYE/FIzuGUBcttiru9u/8kEXabH06Eyv2u/w=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=sQ1_HD7JFBPC0LGZ_GNZTSrdkT_jSC36wG3kQ@mail.gmail.com>
References: <AANLkTi=sQ1_HD7JFBPC0LGZ_GNZTSrdkT_jSC36wG3kQ@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 10 Nov 2010 15:06:07 -0500
X-Google-Sender-Auth: B3Q4ZJYiLTeFG6rYN5NwPcUEv88
Message-ID: <AANLkTimcEiBJtWx2tA=dqm6881g0B7NomXFsZauzfgy8@mail.gmail.com>
Subject: Re: Severe reproducible nouveau breakage in 2.6.36 (and maybe .35)
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 2:28 PM, Andrew Lutomirski <andy@luto.us> wrote:
> Hi all-
>
> Somewhere between 2.6.34-fedora-whatever and 2.6.36, Nouveau became
> extremely broken on my hardware.  It appears to be triggered by a bug
> in my monitor (HP LP2475w), which causes the monitor to disappear from
> DVI when it goes to sleep.  Every time the console blanks (in X or
> otherwise AFAICT) the system crashes oddly but unrecoverably.  This is
> 100% reproducible by Ctrl-Alt-F2 followed by 'echo 1
>>/sys/class/graphics/fb0/blank' *from SSH* and waiting a few seconds
> for the monitor to go to sleep, but it also happens if I just walk
> away from the computer long enough for it to blank itself.  This is
> present on F14's kernel and on 2.6.36 from kernel.org.  This may or
> may not be related to the unreproducible crashes that I used to get
> rarely on 2.6.34.

>
> The best hint I have is from this patch (sorry for whitespace damage):
>

>
> which spews "nv50 got hpd irq" once the display blanks.

I tracked it down.  The interrupt code in 2.6.36 is totally broken ---
it acknowledges the interrupt *in the bottom half*.  This might work
by accident if the bottom half gets queued on a different CPU, but
something probably changed (concurrency-managed workqueues?) that make
the BH end up on the same cpu.  So the cpu starves the BH and there
goes a cpu.

Then the clocksource watchdog hits and takes the whole system down
when it calls stop_machine, which also gets starved on that cpu.

Patch coming.

--Andy
