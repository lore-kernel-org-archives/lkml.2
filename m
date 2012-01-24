Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2AXGSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 01:18:09 -0500
Received: from relay01.digicable.hu ([92.249.128.189]:60257 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab2AXGSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 01:18:07 -0500
Message-ID: <4F1E4CD5.9030306@freemail.hu>
Date: Tue, 24 Jan 2012 07:16:53 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        V4L Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l2: handle multiplication overflow
References: <4EF2FBA2.5070802@freemail.hu> <4F1DA12E.7070906@redhat.com>
In-Reply-To: <4F1DA12E.7070906@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 188.143.83.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab írta:
> Em 22-12-2011 07:42, Németh Márton escreveu:
>> From: Márton Németh <nm127@freemail.hu>
>>
>> When a V4L2 ioctl is executed the memory provided by the caller in user space
>> is copied to the kernel space in video_usercopy() function. To find out
>> how many bytes has to be copied the check_array_args() helper function is used.
>>
>> This patch adds a check for multiplication overflow. Without this check the
>> multiplication may overflow resulting array_size to be zero. This means that
>> later on uninitialized value can trigger NULL pointer exception.
>>
>> The overflow happens because ctrls->count is an __u32 multiplied by a constant
>> coming from sizeof() operator. Multiplication result of two 32bit value may
>> be a 64bit value, thus overflow can happen. Similarly buf->length is an __u32
>> multiplied by a constant coming from sizeof() operator.
>>
>> The chosen error value is -ENOMEM because we are just about to allocate
>> kernel memory to copy data from userspace. We cannot even store the required
>> number of bytes in the variable of size_t type.
>>
>> To trigger the error from user space use the v4l-test 0.19 [1] or essentially
>> the following code fragment:
>>
>> 	struct v4l2_ext_controls controls;
>> 	memset(&controls, 0, sizeof(controls));
>> 	controls.ctrl_class = V4L2_CTRL_CLASS_USER;
>> 	controls.count = 0x40000000;
>> 	controls.controls = NULL;
>> 	ret = ioctl(f, VIDIOC_G_EXT_CTRLS, &controls);
>>
>>
>> References:
>> [1] v4l-test: Test environment for Video For Linux Two (V4L2) API
>>     http://v4l-test.sourceforge.net/
>>
>> Signed-off-by: Márton Németh <nm127@freemail.hu>
>> ---
>>
>> I'm a little bit in doubt whether this is the correct way to check for the
>> multiplication overflow. In case of x86 architecture the MUL insruction [2]
>> can be used to multiply EAX with an other 32bit register, and the 64bit result
>> is placed to EDX:EAX. In case of EDX != 0 the carry and overflow flags are set.
>>
>> This means that executing the MUL instruction on x86 already provides information
>> whether the result fits to 32bit or not. I might use __u64 as a result of the
>> multiplication and check whether the upper 32bit is still zero but the optimal
>> would be to check for the carry or the overflow flag.
>>
>> Still, there could be a special case when the constant from sizeof() operator is
>> a power of 2, in this case the compiler might optimize the multiplication using
>> a shift left. In this case something else is needed.
>>
>> I couldn't really find information about the number of bits for size_t on
>> different architectures. If size_t happens to be at least 64bit on some architecture
>> then this overflow will not happen at all and the array_size will contain the
>> correct value.
>>
>> What do you think?
> 
> Hi Németh,
> 
> IMO, the check should, instead, use a max hard limit for the array size.
> There's no sense on allowing very large arrays there.
> 
> I think that this patch become obsoleted by this one, already merged:

Yes, that merged patch is simple and based on real-world practical
limits and also solves the overflow problem.

> 
> 
> commit 6c06108be53ca5e94d8b0e93883d534dd9079646
> Author: Dan Carpenter <dan.carpenter@oracle.com>
> Date:   Thu Jan 5 02:27:57 2012 -0300
> 
>     [media] V4L/DVB: v4l2-ioctl: integer overflow in video_usercopy()
>     
>     If ctrls->count is too high the multiplication could overflow and
>     array_size would be lower than expected.  Mauro and Hans Verkuil
>     suggested that we cap it at 1024.  That comes from the maximum
>     number of controls with lots of room for expantion.
>     
>     $ grep V4L2_CID include/linux/videodev2.h | wc -l
>     211
>     
>     Cc: stable <stable@vger.kernel.org>
>     Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index e1da8fc..639abee 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -2226,6 +2226,10 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
>  		struct v4l2_ext_controls *ctrls = parg;
>  
>  		if (ctrls->count != 0) {
> +			if (ctrls->count > V4L2_CID_MAX_CTRLS) {
> +				ret = -EINVAL;
> +				break;
> +			}
>  			*user_ptr = (void __user *)ctrls->controls;
>  			*kernel_ptr = (void *)&ctrls->controls;
>  			*array_size = sizeof(struct v4l2_ext_control)
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 6bfaa76..b2e1331 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1132,6 +1132,7 @@ struct v4l2_querymenu {
>  #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
>  
>  /*  User-class control IDs defined by V4L2 */
> +#define V4L2_CID_MAX_CTRLS		1024
>  #define V4L2_CID_BASE			(V4L2_CTRL_CLASS_USER | 0x900)
>  #define V4L2_CID_USER_BASE 		V4L2_CID_BASE
>  /*  IDs reserved for driver specific controls */
> 
> 
> Regards,
> Mauro
> 
> 

