Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2BIF6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 00:58:51 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:27203 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751724Ab2BIF6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 00:58:49 -0500
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bhz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F336084.5050704@am.sony.com>
Date: Wed, 8 Feb 2012 21:58:28 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.26) Gecko/20120129 Thunderbird/3.1.18
MIME-Version: 1.0
To: Dima Zavin <dima@android.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 2/5 v2] logger: simplify and optimize get_entry_len
References: <4F31DC31.6040303@am.sony.com>	<4F31DDC7.1050107@am.sony.com>	<4F32C105.4060700@am.sony.com> <CAPz4a6CFd_L=hDw9uG56ZnhiqqnsPCLTR_3G=Zo5KDnTP=MwiA@mail.gmail.com>
In-Reply-To: <CAPz4a6CFd_L=hDw9uG56ZnhiqqnsPCLTR_3G=Zo5KDnTP=MwiA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/2012 9:15 PM, Dima Zavin wrote:
> On Wed, Feb 8, 2012 at 10:37 AM, Tim Bird<tim.bird@am.sony.com>  wrote:
>> Make this code slightly easier to read, and eliminate calls
>> to sub-routines.  Some of these were previously optimized away
>> by the compiler, but one memcpy was not.
>>
>> In my testing, this makes the code about 20% smaller, and
>> has no sub-routine calls and no branches (on ARM).
>>
>> v2 of this patch is, IMHO, easier to read than v1. Compared to
>> that patch it uses __u8 instead of unsigned char, for
>> consistency with the __u16 val data type, simplifies the
>> conditional expression, adds a another comment, and
>> moves a common statement out of the if.
>>
>> Signed-off-by: Tim Bird<tim.bird@am.sony.com>
>> ---
>>   drivers/staging/android/logger.c |   20 ++++++++++++--------
>>   1 files changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
>> index 92456d7..3475cb7 100644
>> --- a/drivers/staging/android/logger.c
>> +++ b/drivers/staging/android/logger.c
>> @@ -93,20 +93,24 @@ static inline struct logger_log *file_get_log(struct file *file)
>>   * get_entry_len - Grabs the length of the payload of the next entry starting
>>   * from 'off'.
>>   *
>> + * An entry length is 2 bytes (16 bits) in host endian order.
>> + * In the log, the length does not include the size of the log entry structure.
>> + * This function returns the size including the log entry structure.
>> + *
>>   * Caller needs to hold log->mutex.
>>   */
>>   static __u32 get_entry_len(struct logger_log *log, size_t off)
>>   {
>>         __u16 val;
> Could using a union here make things look a little cleaner in the meat
> of the function? Something like
>
> union {
>      __u16 s;
>      __u8 b[2];
> } val;
>
That's a good idea.  I was looking for a way to use a byte array that
wouldn't get misaligned if the function declaration changed.  I'll
test this out and see what it looks like.
>> -       switch (log->size - off) {
>> -       case 1:
>> -               memcpy(&val, log->buffer + off, 1);
>> -               memcpy(((char *)&val) + 1, log->buffer, 1);
>> -               break;
>> -       default:
>> -               memcpy(&val, log->buffer + off, 2);
>> -       }
>> +       /* copy 2 bytes from buffer, in memcpy order, */
>> +       /* handling possible wrap at end of buffer */
>> +
>> +       ((__u8 *)&val)[0] = log->buffer[off];
>> +       if (likely(off+1<  log->size))
>> +               ((__u8 *)&val)[1] = log->buffer[off+1];
> spaces around the + in 'off+1' in the above two lines.
Yeah.  I keep omitting spaces.  I'll fix this, and the ones
mentioned on patch 1/5.
  -- Tim

