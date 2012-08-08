Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab2HHLuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 07:50:07 -0400
Received: from plane.gmane.org ([80.91.229.3]:46663 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab2HHLuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 07:50:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tigran <tigran.avanesov@uni.lu>
Subject: Re: HID device calibration - how to override mapping?
Date: Wed, 8 Aug 2012 11:45:30 +0000 (UTC)
Message-ID: <loom.20120808T133729-135@post.gmane.org>
References: <4F1051CA.4090007@gmail.com> <loom.20120113T175122-168@post.gmane.org> <4F10AE01.4090707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 158.64.77.138 (Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:14.0) Gecko/20100101 Firefox/14.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Enrico Mattea <ocirne94 <at> gmail.com> writes:

> 
> Hi el es, thank you for your answer.
> 
> Il 13/01/2012 18:09, el es ha scritto:
> >
> > released - halfway - pressed
> > 0 - (-32767)<->  (32767) - 0
> > but does it happen in reverse order when releasing pedal ?
> 
> Yes, it does - perfect reverse order.
> > seems the interpretation of this is up to the application really,
> > but /if/ the -32767 to 32767 change happens all around the 'halfway'
> > spot, maybe it is (in the app. engine) interpreted as 'change'
> > and it's effect applied to 'car engine' not directly, but integrated
> > (time-integral function applied) first ?
> I don't think that the change is interpreted, because the clutch value 
> seems to be computed directly, i.e. applying the app. calibration value 
> on the the axis value received from the kernel;
> even if I'm not completely familiar with the app.'s code, the attached 
> code snippet is the interested part of the clutch handler of the app, 
> and it doesn't seem to have any other function applied.
> > I'd say, for the clutch simulation it's the /change-in-time/ that
> > matters, not the /exact/ value; so no 'static' calibration is
> > ever going to be relevant (bar maybe the device telling us when the
> > pedal is fully pressed or fully released - in case app is not tracking
> > it)
> I agree, but trying to calibrate the axis produces the 'jump' effect 
> also on the clutch value, so that either the first half of the axis 
> isn't taken into account, or it produces full clutch already at halfway, 
> and then value 0 after the halfway spot.
> 
> Thank you for your support,
> Ocirne
> 
> Attachment (clutch.cpp): text/x-c++src, 431 bytes

Hi, 

Do you try to make work your pedal with torcs or speed dreams?
Looks like yes... 
I had the same issue with fanatec porche 911 gt2.

I contacted HID driver maintainer, but since for now we don't have a proper
solution (i.e. fixing HID driver), I had to do a dirty thing in the source code.

Replace the fragment you attached in drivers/human/human.cpp with

        switch (cmd[CMD_CLUTCH].type) {
                case GFCTRL_TYPE_JOY_AXIS:
                        clutch = joyInfo->ax[cmd[CMD_CLUTCH].val];

                        // dirty stuff, sorry
                        if (clutch  <= 0) clutch = -clutch;
                        else clutch = 2.0 - clutch;
                        clutch /= 2.0;
                        car->_clutchCmd = fabs(cmd[CMD_CLUTCH].pow *
                                                pow(fabs(clutch),
                                                1.0f / cmd[CMD_CLUTCH].sens));
                        break;

and it should work... without calibration

Regards,
Tigran


