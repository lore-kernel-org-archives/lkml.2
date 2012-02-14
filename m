Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788Ab2BNPTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:19:02 -0500
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:57244 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab2BNPS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:18:57 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F3A7B29.10603@cam.ac.uk>
Date: Tue, 14 Feb 2012 15:18:01 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120124 Thunderbird/10.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Danny Kukawka <danny.kukawka@bisect.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-iio@vger.kernel.org, Danny Kukawka <dkukawka@suse.de>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] adis16080: fix compiler -Wuninitialized
References: <1329230136-26576-1-git-send-email-danny.kukawka@bisect.de> <20120214150455.GN4141@mwanda>
In-Reply-To: <20120214150455.GN4141@mwanda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/2012 3:04 PM, Dan Carpenter wrote:
> On Tue, Feb 14, 2012 at 03:35:36PM +0100, Danny Kukawka wrote:
>> Fix for:
>> drivers/staging/iio/gyro/adis16080_core.c: In function
>>    ‘adis16080_read_raw’:
>> drivers/staging/iio/gyro/adis16080_core.c:99:8: warning: ‘ut’
>>    may be used uninitialized in this function [-Wuninitialized]
>>
>> Initialize ut and change error handling from adis16080_read_raw().
>>
>> Signed-off-by: Danny Kukawka<danny.kukawka@bisect.de>
>> ---
>>   drivers/staging/iio/gyro/adis16080_core.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/iio/gyro/adis16080_core.c b/drivers/staging/iio/gyro/adis16080_core.c
>> index 1815490..e0b2a29 100644
>> --- a/drivers/staging/iio/gyro/adis16080_core.c
>> +++ b/drivers/staging/iio/gyro/adis16080_core.c
>> @@ -82,7 +82,7 @@ static int adis16080_read_raw(struct iio_dev *indio_dev,
>>   			     long mask)
>>   {
>>   	int ret = -EINVAL;
>> -	u16 ut;
>> +	u16 ut = 0;
>>   	/* Take the iio_dev status lock */
>>
>>   	mutex_lock(&indio_dev->mlock);
>> @@ -94,7 +94,7 @@ static int adis16080_read_raw(struct iio_dev *indio_dev,
>>   		if (ret<  0)
>>   			break;
>>   		ret = adis16080_spi_read(indio_dev,&ut);
>> -		if (ret<  0)
>> +		if (ret)
>>   			break;
> Either one of these changes would silence the warning from gcc
> (which is a false positive).  I would keep the "ut = 0;" change and
> leave the error handling the same.  That way we check for less than
> zero consistently instead of checking some for non-zero and some for
> less than zero.
Agreed.  I've always been lazy on this one as it was a false positive, 
but might as well
get rid of it...
>
> I normally wouldn't have commented on this if the changelog had said
> whether it was a gcc false positive or if the code changes the
> behavior.  It really should be mentioned.
>
> If you could put a "Staging:" and an "iio" in the subject, that
> would be grand as well.  Everyone seems to be using the prefix
> "staging:iio:gyro:adis16080" for that file...  I don't know why they
> don't just use slashes if they're going to specify the whole file...
Fair point.   Ah well, habits die hard.  Sometimes we have things like
staging:iio:treewide which is probably why I started doing this...
