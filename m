Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab2GTHYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 03:24:07 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:40422 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2GTHYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 03:24:05 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsRCAI0GCVBV5qoUPGdsb2JhbABFhXSEO68OGQEBAQE3NIIgAQEEASMECwEjIwULCAECGAICJgICFCUKGi6HbAqsBpJ9FIEMiiyFTjJgA5VDhWmNAg
X-IronPort-AV: E=Sophos;i="4.77,621,1336341600"; 
   d="scan'208";a="161093132"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 20 Jul 2012 09:25:10 +0200
To: Chung-Yih Wang =?utf-8?B?KOeOi+W0h+aHvyk=?= <cywang@google.com>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        JJ Ding <dgdunix@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: synaptics - use firmware data for Cr-48
Message-ID: <20120720072510.GA986@polaris.bitmath.org>
References: <1342606923-9997-1-git-send-email-cywang@chromium.org>
 <5006D86C.7030208@canonical.com>
 <CAM2ehZbftDja6CBGjhL3Jp+30DtYJj+8_4e=_wWcj3pCDGD7AA@mail.gmail.com>
 <500832D7.4040805@canonical.com>
 <CAGS+omA-PwoM=U3xP_Gtadaow9SGt555NPWor_-HuvVE8-R3MQ@mail.gmail.com>
 <50084529.2030001@canonical.com>
 <20120719184419.GA3626@polaris.bitmath.org>
 <CAM2ehZaLeJsxCOkqLv9jSko9y3Awix1jjobfTo5WQj8rcrYquA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM2ehZaLeJsxCOkqLv9jSko9y3Awix1jjobfTo5WQj8rcrYquA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 11:14:25AM +0800, Chung-Yih Wang (王崇懿) wrote:
> From our experiments, the assumption of "the slowest corner is the
> stationary finger" is not always true. That is the major reason we want to
> report the firmware data instead of semi-mt.

Oh, but that was precisely the point; the reason it does not hold true
is due to sensor and discretization errors. If we can improve upon
this situation, we get a better model of reality.

> The problem here will be how
> to remove the pulling effect, we measured the pulling effect before and can
> not get a good result as there could be IIR in firmware as well. It seems
> not an easy job to remove the pulling effect cleanly.

Probably a simple filter will work. If the bounding box is moving too
fast for the tracked point to stay in the right corner, the solution
is to use a smaller time step. In practise, keeping the tracked point
as a state in the driver, and updating the bounding box using box ->
(1 - m) box + m box_new. If the tracked point is in the right corner,
let m = 1. If not, choose a smaller m.

> > > * Add a new device property (INVALID_Y_AXIS_CROSSING?) that
> > > describes the exact behavior of this device. I would be ok with this
> > > if everyone else is, but only because proper clickpad behavior
> > > (which I consider very importand) is broken without this knowledge.
> >
> Sounds good to me(but I would rather to have INVALID_CROSSING instead,
> depending on the relative finger positions,  it could still have wrong
> tracking either in X or Y axis crossing)

Propagating information about various sensor defects to userspace
sounds horrid to me. The sooner we can forget about these devices, the
better.

> > > * Leave the device as SEMI_MT, but provide the real locations, and
> > > allow userspace to determine the device vendor/model/etc. If
> > > userspace knows that a specific device behaves in a specific way, it
> > > can do its own quirking handling. Given the specificity of this
> > > behavior to only some devices of one brand, this would be my
> > > suggested resolution to the issue.
> >
> 
> A bit confused here, do you mean we report the real locations instead of
> bounding box the current driver have? I am not quite sure if this will
> affect other existing works in userspace for this semi-mt driver.

I am not entirely opposed to this solution, but I would much rather
see an attempt to improve the bounding box in the driver, since such a
solution could be useful for other devices as well.

Thanks,
Henrik
