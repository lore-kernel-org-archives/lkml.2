Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1IFRDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:03:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47608 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab1IFRDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:03:12 -0400
Message-ID: <4E665249.2040602@canonical.com>
Date: Tue, 06 Sep 2011 10:03:05 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: JJ Ding <jj_ding@emc.com.tw>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 2/6] Input: elantech - use firmware provided x, y ranges
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-3-git-send-email-jj_ding@emc.com.tw> <20110818074756.GE10093@core.coreip.homeip.net> <4E5FCE58.9060906@canonical.com> <87sjobk711.fsf@emc.com.tw>
In-Reply-To: <87sjobk711.fsf@emc.com.tw>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2011 08:22 PM, JJ Ding wrote:
> Hi Chase,
> 
> On Thu, 01 Sep 2011 11:26:32 -0700, Chase Douglas <chase.douglas@canonical.com> wrote:
>> On 08/18/2011 12:47 AM, Dmitry Torokhov wrote:
>>> On Thu, Aug 18, 2011 at 09:57:05AM +0800, JJ Ding wrote:
>>>> +
>>>> +		i = (etd->fw_version > 0x020800 &&
>>>> +		     etd->fw_version < 0x020900) ? 1 : 2;
>>>> +		*x_max = (etd->capabilities[1] - i) * 64;
>>>> +		*y_max = (etd->capabilities[2] - i) * 64;
>>>> +		*y_2ft_max = (*y_max - i) * 64 / 4;
>>>
>>> Hmm, we should have the same range for ST and MT data and scale MT data
>>> if it has lower resolution to match ST.
>>
>> I saw this go by a while back and it made sense to me at the time.
>> However, I've had some thoughts that give me pause.
>>
>> Seth Forshee has been working on getting a semi-mt driver for ALPS
>> devices. The ALPS devices have an interesting mechanism for providing
>> multitouch data, but it boils down to having a resolution of only 15
>> values in the X axis and 11 in the Y axis (it looks possible to
>> extrapolate and get double the resolution, but my point will remain).
>>
>> Let's take the X synaptics module as an example of the repercussions of
>> in-kernel axis scaling. The X synaptics module translates two touch
>> drags into scroll events. Synaptics will want to use the highest
>> resolution axis for generating scroll events. If both the MT and ST axes
>> have the same resolution, it might pick the MT axes for scrolling. On
>> ALPS devices with in-kernel axis scaling that would be a bad choice.
> I don't know about the ALPS devices, but since we already report
> ABS_MT_POSITION_{X,Y} with elantech v2, we have to do the scaling in
> kernel anyway to adhere to multitouch protocol. So I would say it is
> still more appropriate to have the same resolution for ST and MT with
> respect to elantech v2. Maybe ALPS should be considered an exception to this?

The multitouch protocol doesn't require scaling of axes to match, at
least not according to the protocol documentation.

I see that the current code scales the coordinates for v2, but it's only
half-resolution. That's not a huge deal since the resolution of modern
touchpads is very high. We could leave it scaled to not break abi, if
that was a concern. However, with new devices it makes sense to state
the ranges in terms of what the device actually supports. Otherwise,
we're just masking out useful data that userspace could be using.

-- Chase
