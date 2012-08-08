Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab2HHHc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 03:32:56 -0400
Received: from smtp-out-181.synserver.de ([212.40.185.181]:1072 "EHLO
	smtp-out-181.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861Ab2HHHcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 03:32:55 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5666
Message-ID: <50221725.6020704@metafoo.de>
Date: Wed, 08 Aug 2012 09:37:09 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Peter Meerwald <pmeerw@pmeerw.net>
CC: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH] iio/adjd_s311: Fix potential memory leak in adjd_s311_update_scan_mode()
References: <1344407816-13480-1-git-send-email-khoroshilov@ispras.ru> <alpine.DEB.2.01.1208080911260.9959@pmeerw.net>
In-Reply-To: <alpine.DEB.2.01.1208080911260.9959@pmeerw.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 09:17 AM, Peter Meerwald wrote:
> 
>> Do not leak memory by updating pointer with potentially
>> NULL realloc return value.
> 
> I agree
> 
> use of krealloc() was suggested in driver review (see 
> http://www.spinics.net/lists/linux-iio/msg05930.html) to shorten the code; 
> unfortunately, I misunderstood the semantics of krealloc() in case 
> allocation fails

My fault I guess, sorry for that.

> 
> this is the original code:
> 
> 	kfree(data->buffer);
> 	data->buffer = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
> 	if (!data->buffer)
> 		return -ENOMEM;
> 
> I suggest to switch back to that original code, there is no need preserve 
> the data in the buffer as krealloc does

Agreed.

> 
> thanks, p.
> 
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>> ---
>>  drivers/iio/light/adjd_s311.c |   14 ++++++++++----
>>  1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/iio/light/adjd_s311.c b/drivers/iio/light/adjd_s311.c
>> index 1cbb449..0adda5b 100644
>> --- a/drivers/iio/light/adjd_s311.c
>> +++ b/drivers/iio/light/adjd_s311.c
>> @@ -271,12 +271,18 @@ static int adjd_s311_update_scan_mode(struct iio_dev *indio_dev,
>>  	const unsigned long *scan_mask)
>>  {
>>  	struct adjd_s311_data *data = iio_priv(indio_dev);
>> -	data->buffer = krealloc(data->buffer, indio_dev->scan_bytes,
>> +	u16 *new_buffer;
>> +	int ret = 0;
>> +
>> +	new_buffer = krealloc(data->buffer, indio_dev->scan_bytes,
>>  				GFP_KERNEL);
>> -	if (!data->buffer)
>> -		return -ENOMEM;
>> +	if (new_buffer == NULL) {
>> +		kfree(data->buffer);
>> +		ret = -ENOMEM;
>> +	}
>> +	data->buffer = new_buffer;
>>  
>> -	return 0;
>> +	return ret;
>>  }
>>  
>>  static const struct iio_info adjd_s311_info = {
>>
> 

