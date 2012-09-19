Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab2ISBBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 21:01:42 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:37597 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab2ISBBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 21:01:38 -0400
Message-ID: <50591890.9060003@linux.vnet.ibm.com>
Date: Wed, 19 Sep 2012 06:27:52 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: 3.6rc6 slab corruption.
References: <20120918143504.GA30585@redhat.com> <CA+55aFxd08idQXqm+JJ6xD+uzX_f7Qa25zFHb-eWBRQcEDPhkg@mail.gmail.com> <20120918192338.GA25845@phenom.dumpdata.com> <alpine.DEB.2.00.1209181322490.25146@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1209181322490.25146@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12091900-6102-0000-0000-00000240841C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 01:54 AM, David Rientjes wrote:
> On Tue, 18 Sep 2012, Konrad Rzeszutek Wilk wrote:
>
>> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
>> index 2340f69..309b235 100644
>> --- a/fs/debugfs/file.c
>> +++ b/fs/debugfs/file.c
>> @@ -524,6 +524,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_blob);
>>   struct array_data {
>>   	void *array;
>>   	u32 elements;
>> +	struct mutex lock;
>
> This should be a spinlock.


I remember we used debugfs because traceprintks used spinlock.
The code was being accessed from paravirt spinlock.

Sorry for joining late (Time Zone difference)
CCing Jeremy

>
>>   };
>>
>>   static int u32_array_open(struct inode *inode, struct file *file)
>> @@ -580,6 +581,7 @@ static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
>>   	struct array_data *data = inode->i_private;
>>   	size_t size;
>>
>> +	mutex_lock(&data->lock);
>>   	if (*ppos == 0) {
>>   		if (file->private_data) {
>>   			kfree(file->private_data);
>> @@ -594,6 +596,7 @@ static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
>>   	if (file->private_data)
>>   		size = strlen(file->private_data);
>>
>> +	mutex_unlock(&data->lock);
>>   	return simple_read_from_buffer(buf, len, ppos,
>>   					file->private_data, size);
>>   }
>
> Your critical section isn't entirely covered since you're still accessing
> file->private_data in the call to simple_read_from_buffer().  What happens
> if a concurrent reader does file->private_data = NULL immediately after
> your unlock?
>
>

