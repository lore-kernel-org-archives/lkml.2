Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab2AMLKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 06:10:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34026 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab2AMLKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 06:10:13 -0500
Message-ID: <4F101113.4090500@canonical.com>
Date: Fri, 13 Jan 2012 12:10:11 +0100
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: Add EVIOC mechanism for MT slots
References: <1326396275-2492-1-git-send-email-rydberg@euromail.se> <4F0FEC84.7020605@canonical.com> <20120113091556.GA21749@core.coreip.homeip.net>
In-Reply-To: <20120113091556.GA21749@core.coreip.homeip.net>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 10:15 AM, Dmitry Torokhov wrote:
> On Fri, Jan 13, 2012 at 09:34:12AM +0100, Chase Douglas wrote:
>> On 01/12/2012 08:24 PM, Henrik Rydberg wrote:
>>> +	if (put_user(dev->mtsize, &ip[1]))
>>> +		return -EFAULT;
>>> +	for (i = 0; i < dev->mtsize; i++)
>>> +		if (put_user(input_mt_get_value(&mt[i], code), &ip[2 + i]))
>>> +			return -EFAULT;
>>
>> This would be easier to understand if you did:
>>
>> struct input_mt_request *req = (struct input_mt_request *)ip;
>>
>> Then modify the stuff in a straightforward way.
> 
> This is a user pointer, you can't really do it in straightforward way...

I don't know why that is, but as a thought could you do:

struct input_mt_request __user *req =
	(struct input_mt_request __user *)ip;

?

>>
>>> +	return 0;
>>> +}
>>> +
>>>  static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>>>  			   void __user *p, int compat_mode)
>>>  {
>>> @@ -706,6 +731,9 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>>>  		return bits_to_user(dev->propbit, INPUT_PROP_MAX,
>>>  				    size, p, compat_mode);
>>>  
>>> +	case EVIOCGMTSLOTS(0):
>>> +		return evdev_handle_mt_request(dev, size, ip);
>>> +
>>>  	case EVIOCGKEY(0):
>>>  		return bits_to_user(dev->key, KEY_MAX, size, p, compat_mode);
>>>  
>>> diff --git a/include/linux/input.h b/include/linux/input.h
>>> index a637e78..9a73f18 100644
>>> --- a/include/linux/input.h
>>> +++ b/include/linux/input.h
>>> @@ -99,6 +99,30 @@ struct input_keymap_entry {
>>>  	__u8  scancode[32];
>>>  };
>>>  
>>> +/**
>>> + * struct input_mt_request - used by EVIOCGMTSLOTS ioctl
>>> + * @code: ABS_MT code to read
>>> + * @num_values: number of values written to the value array
>>> + * @values: value array, one value per slot
>>> + *
>>> + * The structure is used to retrieve MT slot data. Before the call,
>>> + * code is set to the wanted ABS_MT event type. On return, the value
>>> + * array is filled with the slot values for the specified ABS_MT code,
>>> + * and num_values is set to the actual number of slots.
>>> + *
>>> + * The call argument (len) is the size of the return buffer, satisfying
>>> + *
>>> + * len >= sizeof(input_mt_request) + sizeof(__s32) * number_of_slots
>>> + *
>>> + * If the request code is not an ABS_MT value, or if len is too small,
>>> + * -EINVAL is returned.
>>> + */
>>> +struct input_mt_request {
>>> +	__u32 code;
>>> +	__u32 num_values;
> 
> Hmm, might avoid this one... Userspace can do EVIOCGABS to get number of
> slots and then it will know how much data EVIOCGMTSLOTS will return...

Is it ever possible that a driver could change the number of slots after
initialization? I can't imagine why that would occur, but if we ever
come across a need for it, this would be broken.

-- Chase
