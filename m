Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923Ab1CDRMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:12:36 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60603 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979Ab1CDRMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:12:35 -0500
Subject: Re: BUG at mm/mmap.c:2309 when cx18.ko and cx18-alsa.ko loaded
From: Andy Walls <awalls@md.metrocast.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
In-Reply-To: <AANLkTikoSnBZ5E2tD2d5QsLf4DxmQYi0rYtNRvnU8Fmz@mail.gmail.com>
References: <1299204400.2812.35.camel@localhost>
	 <AANLkTikoSnBZ5E2tD2d5QsLf4DxmQYi0rYtNRvnU8Fmz@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 12:13:04 -0500
Message-ID: <1299258784.14867.16.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-04_07:2011-03-04,2011-03-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1103040121
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 10:50 -0500, Devin Heitmueller wrote:
> On Thu, Mar 3, 2011 at 9:06 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > Hi,
> >
> > I got a BUG when loading the cx18.ko module (which in turn requests the
> > cx18-alsa.ko module) on a kernel built from this repository
> >
> >        http://git.linuxtv.org/media_tree.git staging/for_v2.6.39
> >
> > which I beleive is based on 2.6.38-rc2.
> >
> > The BUG is mmap related and I'm almost certain it has to do with
> > userspace accessing cx18-alsa.ko ALSA device nodes, since cx18.ko
> > doesn't provide any mmap() related file ops.
> >
> > So here is my transcription of a fuzzy digital photo of the screen:
> <snip>
> > I'm not very familiar with mmap() nor ALSA and I did not author the
> > cx18-alsa part of the cx18 driver, so any hints at where to look for the
> > problem are appreciated.
> 
> Hi Andy,
> 
> I'm traveling on business for about two weeks, so I won't be able to
> look into this right now.
> 
> Any idea whether this is some new regression?

I do not know.  I normally don't let cx18-alsa.ko load, due to
PulseAudio's persistence at keeping the device nodes open (which makes
unloading the cx18.ko module for development a hassle.)


>   I'm just trying to
> understand whether this is something that has always been there since
> I originally added the ALSA support to cx18 or whether it's something
> that is new, in which case it might make sense to drag the ALSA people
> into the conversation since there haven't been any changes in the cx18
> driver lately.

I can add some information about what is going on in userspace.  This
was on a Fedora 10 machine.  When devices nodes show up, the HAL daemon
and PulseAudio start using the device nodes right away.

That activity  triggers cx18.ko to do a firmware load which gets udevd
running to satisfy firmware requests, and then the cx18 driver issues
some simple commands to the CX23418 firmware, which will have
acknowledgment interrupts coming back from the CX23418.  I resolved the
firmware race in cx18*.ko a while ago, so I'm confident its not an
issue.

The BUG looks like some sort of mmap() race or memory management problem
outside of the cx18*.ko modules, given that mmput(), which appears to be
an mm specific reference counting function, is involved.

It could also be in ALSA I guess.

I'm not sure how in the cx18-alsa.ko things can be screwed up so badly
that it messes up the kernel's reference counting of mm structures.

I'll take a harder look at it myself this weekend, but the kernel mm
system is a little out of my current realm of experience.  Looks like I
get to learn, because I'm not going to bisect a BUG() that halts the
machine and risks disk corruption every time.

Regards,
Andy



