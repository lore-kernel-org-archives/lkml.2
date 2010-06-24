Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0FXRyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 13:54:53 -0400
Received: from p01c11o148.mxlogic.net ([208.65.144.71]:32776 "EHLO
	p01c11o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab0FXRyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 13:54:52 -0400
X-MXL-Hash: 4c239beb3358ce52-b704258407f0749ac632a192b01f8fc8c1659a8d
X-MXL-Hash: 4c239be67d1933b1-348697fdc4648432d04838b3af6fb0c27a9e6d24
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Joe Perches <joe@perches.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>, "gregkh@suse.de" <gregkh@suse.de>
Date: Thu, 24 Jun 2010 12:54:22 -0500
Subject: RE: [PATCH] Staging: d53155_drv.c: cleanup fbuffer usage
Thread-Topic: [PATCH] Staging: d53155_drv.c: cleanup fbuffer usage
Thread-Index: AcsTw/FuToxAdVOiQaOuyfrkl7RPgAAAE4+w
Message-ID: <0D753D10438DA54287A00B02708426976372DCA6B7@AUSP01VMBX24.collaborationhost.net>
References: <201006240931.13833.hartleys@visionengravers.com>
 <1277401052.1654.59.camel@Joe-Laptop.home>
In-Reply-To: <1277401052.1654.59.camel@Joe-Laptop.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010062201)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.69]
X-AnalysisOut: [v=1.0 c=1 a=hR_7n78Z6NoA:10 a=hO-oPbc3tlwA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=TYbMNos9eHUa9bm6/o8foQ==:17 a=q3]
X-AnalysisOut: [oKHmGdQeJRqZP4QacA:9 a=HQfglXw6VejZXQhm-awA:7 a=E0Yn6861QT]
X-AnalysisOut: [Dqyn7IgfbTUvW-VNUA:4 a=QEXdDO2ut3YA:10 a=QNlXBqI1bHHrNf6C:]
X-AnalysisOut: [21 a=XHVZSM_kw4JGITG4:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o5OHt1im029005

On Thursday, June 24, 2010 10:38 AM, Joe Perches wrote:
> On Thu, 2010-06-24 at 09:31 -0700, H Hartley Sweeten wrote:
> The global symbol dt3155_fbuffer[], declared in dt3155_isr.c, is really
>> just a pointer to dt3155_status[].fbuffer. To improve readability, make
>> some of the really long lines shorter, and make the buffer access more
>> consistent, use &dt3155_status[].fbuffer to access the buffer structure.
>
> I think this would be more consistent/intelligible
> if the temporary wasn't
>	struct dt3155_fbuffer *fb = &dt3155_status[minor].fbuffer;
> but was
>	struct dt3155_status *dts = &dt3155_status[minor];
>
>> @@ -146,11 +148,11 @@ static void quick_stop (int minor)
>>    dt3155_status[minor].state &= ~(DT3155_STATE_STOP|0xff);
>>    /* mark the system stopped: */
>>    dt3155_status[minor].state |= DT3155_STATE_IDLE;
>> -  dt3155_fbuffer[minor]->stop_acquire = 0;
>> -  dt3155_fbuffer[minor]->even_stopped = 0;
>> +  fb->stop_acquire = 0;
>> +  fb->even_stopped = 0;
>>  #else
>>    dt3155_status[minor].state |= DT3155_STATE_STOP;
>> -  dt3155_status[minor].fbuffer.stop_acquire = 1;
>> +  fb->stop_acquire = 1;
>>  #endif
>
> becomes
>
>   dts->state &= ~(DT3155_STATE_STOP|0xff);
>   /* mark the system stopped: */
>   dts->state |= DT3155_STATE_IDLE;
>   dts->fbuffer.stop_acquire = 0;
>   dts->fbuffer.even_stopped = 0;
> #else
>   dts->fbuffer.stop_acquire = 1;
> #endif

I will be posting a follow up patch to remove the dt3155_status[minor] similar
to what you are proposing above.  I just needed to start somewhere that was
still reviewable.  I tried it all in one patch but it's a bit much to review.

Personally I prefer using the 'fb' dereference instead of 'dts->fbuffer' since
there are a number of places in the driver where it gets a bit hard to read.
Also, this file still needs to be reformatted to the kernel coding style but
it's a bit difficult due to the length of some of the lines.

This one for example around line 241:

	  buffer_addr = dt3155_fbuffer[minor]->
	    frame_info[dt3155_fbuffer[minor]->active_buf].addr
	    + (DT3155_MAX_ROWS / 2) * stride;

With 'fb' it becomes:

	  buffer_addr = fb->frame_info[fb->active_buf].addr +
			(DT3155_MAX_ROWS / 2) * stride;

With 'dts->fbuffer' it would be:

	  buffer_addr = dts->fbuffer.frame_info[dts->fbuffer.active_buf].addr +
			(DT3155_MAX_ROWS / 2) * stride;

The one around line 341 is really bad right now:

	      dt3155_fbuffer[minor]->
		frame_info[dt3155_fbuffer[minor]->
			    active_buf].tag = ++unique_tag;

With the 'fb' temporary it's reduced to:

	      fb->frame_info[fb->active_buf].tag = ++unique_tag;

Which you can easily read and see that the tag of the active buffer is being set.

But, I guess either way will work.  I really just want to get rid of all the [minor]
stuff, it's a bit annoying to read.

> Another option might be to use dereferencing inlines.
> 
> static inline struct dt3155_status *dts(int index)
> {
> 	return &dt3155_status[index];
> }
> static inline struct dt3155_fbuffer *fb(int index)
> {
> 	return &(dts(index)->fbuffer);
> }
> 
> I think this isn't as good as the temporary because the
> compiler sometimes doesn't reuse the intermediate addresses
> and the inlines have file rather than function scope.
> 
> It becomes something like:
> 
>   dts(minor)->state &= ~(DT3155_STATE_STOP|0xff);
>   /* mark the system stopped: */
>   dts(minor)->state |= DT3155_STATE_IDLE;
>   fb(minor)->stop_acquire = 0;
>   fb(minor)->even_stopped = 0;
> #else
>   fb(minor)->stop_acquire = 1;
> #endif
> 
> I think this isn't as good as the temporary because the
> compiler sometimes doesn't reuse the intermediate addresses
> and the macros have file rather than function scope.

I also don't like the inline approach.

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
