Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab2D1Ajf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:39:35 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:54938 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758315Ab2D1Ajd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:39:33 -0400
Date: Fri, 27 Apr 2012 20:39:28 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Ben Skeggs <skeggsb@gmail.com>
Cc: Martin Peres <martin.peres@labri.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Linux 3.4-rc4
Message-ID: <20120428003928.GA16805@elliptictech.com>
References: <CA+55aFzQD4UyPVDQesrWq7JkM=BoQevdJpQt1YyaG10MtfM-Pw@mail.gmail.com>
 <20120422040715.GA30689@elliptictech.com>
 <CA+55aFwGrb_sOjHFWe6tYwf8mmNsFbqKAhz=bq2ofiU+F+wVvA@mail.gmail.com>
 <20120422164023.GA32342@elliptictech.com>
 <20120423000554.GA893@elliptictech.com>
 <20120423024558.GD13840@phenom.dumpdata.com>
 <20120424010345.GA30674@elliptictech.com>
 <20120425013537.GA11959@elliptictech.com>
 <1335322574.1821.8.camel@nisroch>
 <1335504021.5311.0.camel@nisroch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335504021.5311.0.camel@nisroch>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On 2012-04-27 15:20 +1000, Ben Skeggs wrote:
> Does this patch help you at all?
> 
> http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=a3a285f17867f0018de798b5ee85731ec1268305

Yes.  I cherry-picked this patch on top of Linus' master (3.4-rc4+) and
this appears to solve the "black screen on VGA" problem described in the
original report.  Thanks!

Unfortunately, that's not the end of my VGA-related regressions. :(

While tracking down the black screen issue, I've been having the monitor
directly connected to the video card the whole time, but now when I'm
connected through my KVM switch (an IOGear GCS1804), it appears that
something's going wrong with reading the EDID, because the available
modes are all screwed up (both console and X decide they want to drive
the display at 1024x768).  Here's the output of xrandr on 3.2.15:

  % xrandr
  Screen 1: minimum 320 x 200, current 1600 x 1200, maximum 4096 x 4096
  VGA-1 connected 1600x1200+0+0 (normal left inverted right x axis y axis) 352mm x 264mm
     1600x1200      75.0*+   70.0     65.0     60.0
     1280x1024      85.0 +   75.0     60.0
     1920x1440      60.0
     1856x1392      60.0
     1792x1344      60.0
     1920x1200      74.9     59.9
     1680x1050      84.9     74.9     60.0
     1400x1050      85.0     74.9     60.0
     1440x900       84.8     75.0     59.9
     1280x960       85.0     60.0
     1360x768       60.0
     1280x800       84.9     74.9     59.8
     1152x864       75.0
     1280x768       84.8     74.9     59.9
     1024x768       85.0     75.1     75.0     70.1     60.0     43.5     43.5
     832x624        74.6
     800x600        85.1     72.2     75.0     60.3     56.2
     848x480        60.0
     640x480        85.0     75.0     72.8     72.8     66.7     60.0     59.9
     720x400        85.0     87.8     70.1
     640x400        85.1
     640x350        85.1
     320x200       165.1

And on 3.4-rc4+ (with your patch cherry-picked):

  % xrandr
  Screen 1: minimum 320 x 200, current 1024 x 768, maximum 4096 x 4096
  VGA-1 connected 1024x768+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
     1024x768       60.0*
     800x600        60.3     56.2
     848x480        60.0
     640x480        59.9
     320x200       165.1

Running xrandr on 3.4-rc4+ also causes the screen to go black for a
second when it does not on 3.2.15.  It also causes several messages of
the form

  [drm] nouveau 0000:01:00.0: Load detected on output B

to be logged.  Also, looking at /sys/class/drm/card0-VGA-1/edid I see
that it is empty on 3.4-rc4+ and it is correct on 3.2.15.  Things seem
to work OK when the KVM is not involved.

This is probably caused by a different commit than the black screen
because I also saw this problem on the 3.3.3+reverts kernel; I just
haven't noticed it until now because, well, the VGA wasn't working at
all until now.

Anyway, I can try to track down what causes this one next week...

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

