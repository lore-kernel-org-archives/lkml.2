Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0KHQyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:54:20 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:47138 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab0KHQyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:54:19 -0500
Message-ID: <4CD82B28.4060706@seas.upenn.edu>
Date: Mon, 08 Nov 2010 11:54:00 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chasedouglas@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH] input: Introduce light-weight contact tracking
References: <1289161108-32309-1-git-send-email-rydberg@euromail.se> <4CD724BC.8020702@seas.upenn.edu> <4CD80FCB.20903@euromail.se>
In-Reply-To: <4CD80FCB.20903@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-11-08_08:2010-11-08,2010-11-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1011080081
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2010 09:57 AM, Henrik Rydberg wrote:
> Hi Rafi,
>
> what tree does this patch apply to?

It should apply to the torvalds/linux-2.6 master branch.

> I think the situation with this driver is slightly cumbersome. Perhaps there is
> a small conflict of interest here, but I hope we will be able to resolve it
> quickly. I see little benefit in duplicating the tracking efforts. Since greedy
> matching algorithms are not provably suited to the task, I think any such
> algorithm should first be tested and benchmarked thoroughly, preferably in the
> mtdev context.
>
> Regarding the ntrig driver, fact is it does not work very well. Contacts are
> occasionally dropped, and spurious ghosts make multitouch gestures not work
> properly. There are also many parameters in the driver, which are difficult to
> use in practice. Therefore, in the Ubuntu 10.10 kernel, a rather large ntrig
> patch has been applied, improving those issues.
>
> The way the data is extracted in 2.6.36 leads to many dropped contacts. The
> ubuntu patch remedies this problem, so no particular logic for drops is needed.
> Instead, more effort is put into removing ghost contacts, which greatly improves
> the actual experience with multitouch gestures.
>
> In order for ghost removal to work, the contacts need to be tracked. Because of
> the deficiencies of the ntrig firmware, this needs to be done in software. The
> ubuntu patch contains a simple greedy tracking mechanism, which did not seem
> good enough to upstream, so I never upstreamed it.
>
> With the proposed matcher (http://lkml.org/lkml/2010/11/7/122), the situation is
> different. The ubuntu patch can be modified to use the matcher, which I believe
> will make it ready for upstream. Since the patch also removes all parameters
> from the driver, the usability aspect is improved.
>
> With the above said, it seems to me that the simplest way forward is to modify
> and upstream the ubuntu patches. Would you agree?
>
> Regarding support for more than four fingers, there is a single device which
> reports six contacts from the firmware. Getting four good contacts out of it
> will be a major improvement, and IMO good enough. It seems likely that future
> firmware will handle tracking properly, so this should all be a stop-gap measure
> anyways.
>
> We talked earlier about the possibility to perform automatic calibration of the
> driver. This would be the last major step towards a fully functional,
> maintenance-free driver.
>
> I hope we will be able to agree on the direction of this driver, such that
> duplicated work is minimized and the focus stays with the user experience of the
> ntrig devices.

The "complex" set of parameters was intended for more advanced users to give 
some feedback to help improve the driver.  Though given the lack of feedback, I 
guess you're right that there's little reason to expose them to users.

The ubuntu 10.10 code does do filtering better than without filtering, but in 
trying it I've been seeing ghosts and have needed to calibrate multiple times 
per day (though that may be the result of a new screen being a little off). 
Furthermore while ripping out the filter code, you also ripped out single touch 
support for single touch firmwares, which apparently a few people still use.

Even without the ghost problem, it simply does not track as well.  The ntrig 
only reports every 8-24ms which is a long enough period to move quite a 
distance.  In drawing up corner cases I realized that motion where two fingers 
are co-linear with the vector of motion require quite a bit of care to avoid 
perverting the tracking.  Greedily assigning matches based purely on distance 
can cause a flip.  Even global distance minimization is not reliable when we use 
linear distance as the cost.  A full analysis would require quadric distances 
and the global minimization tends to be an n^3 approach.  I'm sure we could 
reduce that a bit, but it just seems a bit heavy handed.

By contrast just a little bit of extra work to estimate the position based on 
the difference in position of the previous two points (which every algorithm 
discussed seems to do anyway) doesn't seem that egregious.

The style of the code still assumes that we might want to adjust the 
aggressiveness of filtering ghosts and drops.  I agree it would be nice to be 
able to come up with a single value for each and hard code it, but I'm not 
willing to just assume that I can determine that value.  Also, for graceful 
degradation and repair, I would like to be able to code it so that those 
thresholds grow a little bit as a device drifts and then drop them again when 
calibration is run.


Also, if you're going to criticize code for complexity, I would recommend some 
comments that explain your code beyond "this is a generated table, don't change it".

Rafi
