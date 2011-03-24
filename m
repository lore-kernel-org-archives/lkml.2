Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab1CXKw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 06:52:29 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:46589 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab1CXKw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 06:52:28 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D8B22B8.1070903@cam.ac.uk>
Date: Thu, 24 Mar 2011 10:53:44 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Ryan Mallon <ryan@bluewatersys.com>
CC: linux-kernel@vger.kernel.org, greg@kroah.com, rusty@rustcorp.com.au,
        adobriyan@gmail.com
Subject: Re: [PATCH 2/3] debugfs: move to new kstrtobool function
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk> <1300887554-19031-3-git-send-email-jic23@cam.ac.uk> <4D8A55F7.1070802@bluewatersys.com>
In-Reply-To: <4D8A55F7.1070802@bluewatersys.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/11 20:20, Ryan Mallon wrote:
> On 03/24/2011 02:39 AM, Jonathan Cameron wrote:
>> No functional changes requires that we eat errors from
>> kstrtobool.  Note *val is still only updated if a valid
>> input is found.
>>
>> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>> ---
>>  fs/debugfs/file.c |   19 ++++++-------------
>>  1 files changed, 6 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
>> index 89d394d..fed4485 100644
>> --- a/fs/debugfs/file.c
>> +++ b/fs/debugfs/file.c
>> @@ -429,25 +429,18 @@ static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
>>  {
>>  	char buf[32];
>>  	int buf_size;
>> +	int ret;
>> +	bool bv;
>>  	u32 *val = file->private_data;
>>  
>>  	buf_size = min(count, (sizeof(buf)-1));
>>  	if (copy_from_user(buf, user_buf, buf_size))
>>  		return -EFAULT;
>>  
>> -	switch (buf[0]) {
>> -	case 'y':
>> -	case 'Y':
>> -	case '1':
>> -		*val = 1;
>> -		break;
>> -	case 'n':
>> -	case 'N':
>> -	case '0':
>> -		*val = 0;
>> -		break;
>> -	}
>> -	
>> +	ret = kstrtobool(buf, &bv);
>> +	if (!ret)
>> +		*val = bv;
>> +
>>  	return count;
> 
> Shouldn't this be:
> 
> 	ret = kstrtobool(buf, &bv);
> 	if (ret)
> 		return ret;
> 
> 	*val = bv;
> 	return count;
> 
That is indeed what one would normally expect to see.
However, I think we want to maintain what is already happening in
the function and previously it never returned an error for
an invalid value.

Now that's not to say I'd be against a 'fix' for that issue, but
it should be in a separate patch series as it has nothing to do
with the use of this new function.

Jonathan


