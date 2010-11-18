Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab0KRIrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:47:00 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61817 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab0KRIq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:46:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type;
        b=cyWOYVe3Sfn/fpotkDX3tvhNcz95A8Pz+gNjK8avJirKR/YiT1mVi5CUIczHYWOynz
         SVz1pu676dCSv1DGVxrAnpOtPOKmbmt0iuuWiGddAI8xTExneh04YKU5l0xqWddnLIPl
         ynOroOPrccn8LTfR8SkLkqDNSkQjizH+Nk69Q=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 18 Nov 2010 00:46:37 -0800
X-Google-Sender-Auth: 57enKyhgpv8xsK47_TFLGc0KFq8
Message-ID: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
Subject: Challenges with doing hardware bring up with Linux first
To: linux-kernel@vger.kernel.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>, Greg KH <greg@kroah.com>,
        David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to see hardware bring up at companies being done with Linux.
>From what I see its what is typically done anyway since it seems like
the easiest platform to hack on but often times its done with closed
source / proprietary Linux drivers though. I'd prefer if this was done
with targeted upstream Linux drivers first. There are a few challenges
with this though. For starters hardware teams typically want to get
hardware brought up as fast as possible to be able to sell chipsets.
Its always a race. Proper Linux upstream support will get there but
depending on the company this may mean this gets done after the
proprietary driver approach is done first or simply until you have a
big enough customer to justify it.

There are two reasons why we have proprietary drivers today. One is
old tradition put forward by companies who have no software quality
control other than simply testing the damn driver and where no real
software engineering analysis is being done on the software. This has
allowed companies to write sloppy quick drivers for hardware for years
but this has also created a few important trends in driver development
practices which prevents doing hardware bring up on Linux first. The
biggest trend I see is that of sharing code between Operating Systems.
If a company can use the same driver code to build a Windows, Mac OS X
and Linux driver they'd do it. Sometimes though Operating System
vendors may push back though at an architectural level though and may
require hardware manufacturers to use more of their own OS stacks for
generic purposes. One case is the 802.11 stack. Modern Windows 7 and
Apple OS X driver have their own 802.11 stacks and Linux is no
different. This means you share less and less code as more code
becomes generic between drivers and Operating System vendors smarten
up and put some of this code in a form other companies can use in a
generic fashion. This ultimately makes the maintainable driver smaller
and smaller.

The amount of code sharing between different Operating Systems then at
least for 802.11 drivers becomes smaller and smaller. Some Operating
System vendors though do not have any 802.11 stack at all, so you
still need one for those companies. Maintaining these drivers then
becomes more and more of a challenge. Linux however is still very
attractive as a platform for doing hardware bring up though and it is
used today for that purposes but since you typically have no software
code quality oversight over proprietary drivers and since its easier
to do that those drivers typically get written first, even if hardware
bring up will be done on Linux first as the base OS. The proper
upstream drivers then typically then gets done as a secondary step
where the code gets a good amount of churn and review for upstream
considerations, the software this process produces ends up
highlighting the benefits of the good software engineering practices
we have in place today on Linux. These software practices are seen as
a higher burden though, a blocker for fast delivery of software and
fast hardware bring up.

This is of course all subjective but my take is that doing hardware
bring up first on Linux will push companies to start highly
prioritizing driver architecture design even more carefully. I am not
saying this is done done today, its just that the freedoms granted by
other Operating System vendors tends to produce lower quality and IMHO
completely unmaintainable drivers in the long run. The challenge
though is how you can still compete with the speed required by
hardware teams for hardware bring up pace and with the goals to help
share as much code between different Operating Systems supported. This
is a broad topic but I'd like to ask for ideas how we can help
companies better architect drivers so that the flexibility of Linux
upstream pushes companies to actually do proper upstream drivers first
but also help companies so that they can envision a good way to also
get their other OS drivers complete.

I think Atheros' approach and commitment to upstream is a perfect
example of how a company can change for the better. It however is
still faced with the above dilemmas. My own mental picture to help
resolve this is to push for permissive licensed software for code you
want to share between Linux and other Operating Systems, and
everything else can be independent code. For ath9k in particular this
means we keep ath9k_hw shared between our Operating Systems and that's
it. In addition to this I believe opening up the common drivers for
Windows and OS X / etc would be the next step, under a permissive
license. The other steps I believe would be important would be to also
work with other companies on a common permissive licensed 802.11 stack
where other Operating System vendors have no 802.11 stack. And of
course, a shared common OS agnostic set of APIs which can be shared by
companies. None of this would be used by Linux, of course though. For
Atheros then it would be:


           some common OS wrapper crap
                              |
                              |
                              v
                  Atheros HAL code
                   ^                          ^
                  /                            \
    some common OS        no OS de-wrapper (see note A)
    de-wrapper scripts              \
                /                                \
              v                                 v
ath9k_hw                                   common driver for OSes
         |                                                       |
                        \
         |                                                       |
                            \
         v                                                      v
                              \
 Other Linux driver stuff
                       \
   (ath9k, ath9k_common,                  common 802.11 stack
solution for OSes with their own 802.11 stack
    ath, mac80211, cfg80211)                        |
                                                                       |
                                                                       v
                                  solution for OSes with no 802.11 stack

A. Technically from our experience we see that not alot of OS calls
actually are needed in hardware code so this may be small fortunately

Can Linux help in any way? What if we used staging for a common driver
architecture for different OSes? Most of those staging drivers already
have some sort of OS agnostic cruft, why not try to help hardware
vendors by providing them with a common OS agnostic solution they can
share? Is this not out turf? If its not, are we perfectly OK in being
second citizens so long as the driver eventually gets done on proper
upstream Linux ? I'm not OK with it and hence my e-mail. I'm looking
for ideas and thoughts on this. Please no trolls, would really just
like some constructive discussions on this. As I see it maybe we can
move some of this OS agnostic crap into staging, and then use spatch
to write tools to de-unwrap crap to Linux specific stuff and help
maintain it. What this does is it moves OS agnostic crap out as a
community effort to help aid proper development and porting for Linux.
Since we'd maintain the crap / scripts / de-wrappers, we'd likely be
able to get drivers quicker and can have a framework to help companies
who still [1] need to support other Operating Systems.

[1] ;)

  Luis
