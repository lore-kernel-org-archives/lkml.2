Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab1AZT1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:27:10 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:12132 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751435Ab1AZT1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:27:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAI8EQE1Ld/sX/2dsb2JhbAAMhAbNfZEDgSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,381,1291611600"; 
   d="scan'208";a="89333958"
Message-ID: <4D407589.2030909@teksavvy.com>
Date: Wed, 26 Jan 2011 14:27:05 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D4004F9.6090200@redhat.com> <4D401CC5.4020000@redhat.com> <4D402D35.4090206@redhat.com> <20110126165132.GC29163@core.coreip.homeip.net> <4D4059E5.7050300@redhat.com> <20110126182415.GB29268@core.coreip.homeip.net>
In-Reply-To: <20110126182415.GB29268@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-26 01:24 PM, Dmitry Torokhov wrote:
> On Wed, Jan 26, 2011 at 03:29:09PM -0200, Mauro Carvalho Chehab wrote:
>> Em 26-01-2011 14:51, Dmitry Torokhov escreveu:
>>> On Wed, Jan 26, 2011 at 12:18:29PM -0200, Mauro Carvalho Chehab wrote:
>>>> diff --git a/input.c b/input.c
>>>> index d57a31e..a9bd5e8 100644
>>>> --- a/input.c
>>>> +++ b/input.c
>>>> @@ -101,8 +101,8 @@ int device_open(int nr, int verbose)
>>>>  		close(fd);
>>>>  		return -1;
>>>>  	}
>>>> -	if (EV_VERSION != version) {
>>>> -		fprintf(stderr, "protocol version mismatch (expected %d, got %d)\n",
>>>> +	if (EV_VERSION > version) {
>>>> +		fprintf(stderr, "protocol version mismatch (expected >= %d, got %d)\n",
>>>>  			EV_VERSION, version);
>>>
>>> Please do not do this. It causes check to "float" depending on the
>>> version of kernel headers it was compiled against.
>>>
>>> The check should be against concrete version (0x10000 in this case).
>>
>> The idea here is to not prevent it to load if version is 0x10001.
>> This is actually the only change that it is really needed (after applying
>> your KEY_RESERVED patch to 2.6.37) for the tool to work. Reverting it causes
>> the error:
> 
> You did not understand. When comparing against EV_VERSION, if you
> compile on 2.6.32 you are comparing with 0x10000. If you are compiling
> on 2.6.37 you are comparing with 0x10001 as EV_VERSION value changes
> (not the value returned by EVIOCGVERSION, the value of the _define_
> itself).
> 
> The proper check is:
> 
> #define EVDEV_MIN_VERSION 0x10000
> 	if (version < EVDEV_MIN_VERSION) {
> 		fprintf(stderr,
> 			"protocol version mismatch (need at least %d, got %d)\n",
> 			EVDEV_MIN_VERSION, version);
> 		...
> 	}


Guys, NO!

The proper check is actually to remove all of that silly VERSION testing
from the userspace binary.  And then have it try EVIOCGKEYCODE_V2 first.
If EVIOCGKEYCODE_V2 fails (-ENOTTY, -EINVAL, or -ENOSYS), then
have it fall back to trying to use EVIOCGKEYCODE.

Of course this does assume that the new EVIOCGKEYCODE_V2 interface uses
correct ioctl return values..

Cheers
