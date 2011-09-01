Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab1IAS0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 14:26:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab1IAS0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 14:26:40 -0400
Message-ID: <4E5FCE58.9060906@canonical.com>
Date: Thu, 01 Sep 2011 11:26:32 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: JJ Ding <jj_ding@emc.com.tw>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 2/6] Input: elantech - use firmware provided x, y ranges
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-3-git-send-email-jj_ding@emc.com.tw> <20110818074756.GE10093@core.coreip.homeip.net>
In-Reply-To: <20110818074756.GE10093@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 12:47 AM, Dmitry Torokhov wrote:
> On Thu, Aug 18, 2011 at 09:57:05AM +0800, JJ Ding wrote:
>> +
>> +		i = (etd->fw_version > 0x020800 &&
>> +		     etd->fw_version < 0x020900) ? 1 : 2;
>> +		*x_max = (etd->capabilities[1] - i) * 64;
>> +		*y_max = (etd->capabilities[2] - i) * 64;
>> +		*y_2ft_max = (*y_max - i) * 64 / 4;
> 
> Hmm, we should have the same range for ST and MT data and scale MT data
> if it has lower resolution to match ST.

I saw this go by a while back and it made sense to me at the time.
However, I've had some thoughts that give me pause.

Seth Forshee has been working on getting a semi-mt driver for ALPS
devices. The ALPS devices have an interesting mechanism for providing
multitouch data, but it boils down to having a resolution of only 15
values in the X axis and 11 in the Y axis (it looks possible to
extrapolate and get double the resolution, but my point will remain).

Let's take the X synaptics module as an example of the repercussions of
in-kernel axis scaling. The X synaptics module translates two touch
drags into scroll events. Synaptics will want to use the highest
resolution axis for generating scroll events. If both the MT and ST axes
have the same resolution, it might pick the MT axes for scrolling. On
ALPS devices with in-kernel axis scaling that would be a bad choice.

It's trivial to project the MT and ST axes onto each other in userspace.
I suggest we report the real range and resolution of ST and MT axes
independently.

-- Chase
