Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab1IAByl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 21:54:41 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:34770 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410Ab1IAByk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 21:54:40 -0400
Message-ID: <4E5EE5DB.3030101@gmail.com>
Date: Thu, 01 Sep 2011 11:54:35 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/24] fix default __strnlen_user macro
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>	 <1314826019-22330-2-git-send-email-msalter@redhat.com>	 <4E5EC3FE.10307@gmail.com> <1314841084.2344.113.camel@deneb.redhat.com>
In-Reply-To: <1314841084.2344.113.camel@deneb.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/11 11:38, Mark Salter wrote:
> On Thu, 2011-09-01 at 09:30 +1000, Ryan Mallon wrote:
>> On 01/09/11 07:26, Mark Salter wrote:
>>> The existing __strnlen_user macro simply resolved to strnlen. However, the
>>> count returned by strnlen_user should include the NULL byte. This patch
>>> fixes the __strnlen_user macro to include the NULL byte in the count.
>>>
>>> Signed-off-by: Mark Salter<msalter@redhat.com>
>>> ---
>>>    include/asm-generic/uaccess.h |    2 +-
>>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
>>> index ac68c99..1d0fdf8 100644
>>> --- a/include/asm-generic/uaccess.h
>>> +++ b/include/asm-generic/uaccess.h
>>> @@ -289,7 +289,7 @@ strncpy_from_user(char *dst, const char __user *src, long count)
>>>     * Return 0 on exception, a value greater than N if too long
>>>     */
>>>    #ifndef __strnlen_user
>>> -#define __strnlen_user strnlen
>>> +#define __strnlen_user(s, n) (strnlen((s), (n)) + 1)
>>>    #endif
>> I don't think this is correct because if you hit maxlen you will add one
>> to it. e.g. __strnlen_user("abcd\0", 3) would return 4 instead of 3.
> Yes, one would think so, but that doesn't seem to be the case. Looking
> at various places that call strnlen_user, you'll find checks for that.
> For one example, mm/util.c:
>
>      char *strndup_user(const char __user *s, long n)
>      {
> 	char *p;
> 	long length;
>
> 	length = strnlen_user(s, n);
>
> 	if (!length)
> 		return ERR_PTR(-EFAULT);
>
> 	if (length>  n)
> 		return ERR_PTR(-EINVAL);

Sure, but that isn't a good reason to not write it correctly according 
to the API description. There are also places where that check doesn't 
happen like fs/exec.c and the rather dodgy looking usage in 
kernel/auditsc.c which appears to rely on it returning n + 1 in the 
maxlen case.

It should either be changed as I suggested, or the comment in uaccess.h 
should be updated to reflect the actual behaviour of the function 
(stating that it returns n + 1 in the case where n is reached). Either 
way, its probably worth doing a quick check through the arch specific 
versions to see what their behaviour really is. It looks like there are 
potentially some subtle bugs at the callsites.

~Ryan

