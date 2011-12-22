Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1LVUC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:02:27 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:56013 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab1LVUCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:02:24 -0500
Message-ID: <4EF38CBD.3080302@linux.vnet.ibm.com>
Date: Thu, 22 Dec 2011 18:02:05 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/3] TPM: Close data_pending and data_buffer races
References: <1323196162-2717-1-git-send-email-tim.gardner@canonical.com> <1323196162-2717-3-git-send-email-tim.gardner@canonical.com> <4EF0B9F8.9020305@linux.vnet.ibm.com> <4EF0E465.5060704@canonical.com> <4EF36C1F.6040409@linux.vnet.ibm.com> <4EF37A7A.2060504@canonical.com>
In-Reply-To: <4EF37A7A.2060504@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11122220-1524-0000-0000-000000A56127
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks, Rajiv Andrade Security Development IBM Linux Technology Center

On 22-12-2011 16:44, Tim Gardner wrote:
> On 12/22/2011 10:42 AM, Rajiv Andrade wrote:
>> On 20-12-2011 17:39, Tim Gardner wrote:
>>> On 12/20/2011 09:38 AM, Rajiv Andrade wrote:
>>>> On 06/12/11 16:29, Tim Gardner wrote:
>>>>> There is a race betwen tpm_read() and tpm_write where both
>>>>> chip->data_pending
>>>>> and chip->data_buffer can be changed by tpm_write() when tpm_read()
>>>>> clears chip->data_pending, but before tpm_read() grabs the mutex.
>>>>>
>>>>> Protect changes to chip->data_pending and chip->data_buffer by
>>>>> expanding
>>>>> the scope of chip->buffer_mutex.
>>>>>
>>>>> Reported-by: Seth Forshee<seth.forshee@canonical.com>
>>>>> Cc: Debora Velarde<debora@linux.vnet.ibm.com>
>>>>> Cc: Rajiv Andrade<srajiv@linux.vnet.ibm.com>
>>>>> Cc: Marcel Selhorst<m.selhorst@sirrix.com>
>>>>> Cc: tpmdd-devel@lists.sourceforge.net
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Tim Gardner<tim.gardner@canonical.com>
>>>>> ---
>>>>> drivers/char/tpm/tpm.c | 17 +++++++++--------
>>>>> 1 files changed, 9 insertions(+), 8 deletions(-)
>>>>>
>>>>> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
>>>>> index b366b34..70bf9e5 100644
>>>>> --- a/drivers/char/tpm/tpm.c
>>>>> +++ b/drivers/char/tpm/tpm.c
>>>>> @@ -1074,12 +1074,15 @@ ssize_t tpm_write(struct file *file, const
>>>>> char __user *buf,
>>>>> struct tpm_chip *chip = file->private_data;
>>>>> size_t in_size = size, out_size;
>>>>>
>>>>> + mutex_lock(&chip->buffer_mutex);
>>>>> +
>>>>> /* cannot perform a write until the read has cleared
>>>>> either via tpm_read or a user_read_timer timeout */
>>>>> - while (atomic_read(&chip->data_pending) != 0)
>>>>> + while (atomic_read(&chip->data_pending) != 0) {
>>>>> + mutex_unlock(&chip->buffer_mutex);
>>>>> msleep(TPM_TIMEOUT);
>>>>> -
>>>>> - mutex_lock(&chip->buffer_mutex);
>>>>> + mutex_lock(&chip->buffer_mutex);
>>>>> + }
>>>>>
>>>>> if (in_size> TPM_BUFSIZE)
>>>>> in_size = TPM_BUFSIZE;
>>>>> @@ -1112,22 +1115,20 @@ ssize_t tpm_read(struct file *file, char
>>>>> __user *buf,
>>>>>
>>>>> del_singleshot_timer_sync(&chip->user_read_timer);
>>>>> flush_work_sync(&chip->work);
>>>>> - ret_size = atomic_read(&chip->data_pending);
>>>>> - atomic_set(&chip->data_pending, 0);
>>>>> + mutex_lock(&chip->buffer_mutex);
>>>>> + ret_size = atomic_xchg(&chip->data_pending, 0);
>>>>> if (ret_size> 0) { /* relay data */
>>>>> ssize_t orig_ret_size = ret_size;
>>>>> if (size< ret_size)
>>>>> ret_size = size;
>>>>>
>>>>> - mutex_lock(&chip->buffer_mutex);
>>>>> rc = copy_to_user(buf, chip->data_buffer, ret_size);
>>>>> memset(chip->data_buffer, 0, orig_ret_size);
>>>>> if (rc)
>>>>> ret_size = -EFAULT;
>>>>
>>>> What about just moving atomic_set(&chip->data_pending, 0); to here?
>>>> If I'm not missing anything, this would be cleaner.
>>>>
>>>> Rajiv
>>>
>>> I'm not sure I agree. Moving just that statement doesn't close the
>>> race. Perhaps you could send me your version of this patch so that its
>>> clear what you are suggesting.
>>>
>>> rtg
>> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
>> index 6a8771f..6a37212b 100644
>> --- a/drivers/char/tpm/tpm.c
>> +++ b/drivers/char/tpm/tpm.c
>> @@ -1210,7 +1210,6 @@ ssize_t tpm_read(struct file *file, char __user 
>> *buf,
>> del_singleshot_timer_sync(&chip->user_read_timer);
>> flush_work_sync(&chip->work);
>> ret_size = atomic_read(&chip->data_pending);
>> - atomic_set(&chip->data_pending, 0);
>> if (ret_size> 0) { /* relay data */
>> if (size< ret_size)
>> ret_size = size;
>> @@ -1223,6 +1222,7 @@ ssize_t tpm_read(struct file *file, char __user 
>> *buf,
>> mutex_unlock(&chip->buffer_mutex);
>> } + atomic_set(&chip->data_pending, 0);
>> return ret_size;
>> }
>>
>> If we reset chip->data_pending after the buffer was copied to userspace,
>> it's guaranteed that tpm_write() won't touch such buffer before 
>> tpm_read()
>> handles it, given it polls chip->data_pending first.
>>
>
> NAK - this patch makes it worse (if I'm reading your email client 
> garbled patch correctly). Now it races with tpm_write() as well as 
> timeout_work(). You cannot futz with chip->data_pending outside of the 
> exclusion zones. Consider what will happen if a user process just 
> loops doing reads. chip->data_pending gets cleared every time 
> tpm_read() is called, regardless of what tpm_write() or timeout_work() 
> are doing at the time.

Not sure how it's displaying for you, but your mail client is eating all 
whitespaces when sending. Look back here what I said:

http://marc.info/?l=tpmdd-devel&m=132439922903276&w=2

It's inside the mutex region.

This would require another fix though. tpm_write() doesn't check 
tpm_transmit return code (and it should).
In case it returns an error (< 0), chip->data_pending would remain the 
same forever with that change.

>
> tpm_read() / tpm_write() is a simple producer consumer model. Just use 
> mutexes in an uncomplicated way. There is no need for data_pending to 
> be atomic_t.
>
> rtg

That's a separate patch, 3/3, which is good once chip->data_pending is 
handled inside such regions.

Rajiv

