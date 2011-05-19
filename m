Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779Ab1ESRpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:45:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18475 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab1ESRpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:45:52 -0400
Message-ID: <4DD55738.3080405@oracle.com>
Date: Thu, 19 May 2011 10:45:28 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tristan Ye <tristan.ye@oracle.com>
CC: josef@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, viro@ZenIV.linux.org.uk,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Implement llseek()
References: <1305773084-19296-1-git-send-email-sunil.mushran@oracle.com> <1305773084-19296-3-git-send-email-sunil.mushran@oracle.com> <4DD4DF4C.501@oracle.com>
In-Reply-To: <4DD4DF4C.501@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4DD5574C.00F3:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2011 02:13 AM, Tristan Ye wrote:
>> +	if (inode->i_size == 0 || *offset>= inode->i_size) {
>> +		ret = -ENXIO;
>> +		goto out_unlock;
>> +	}
> Why not using if (*offset>= inode->i_size) directly?

duh!

> +			BUG_ON(cpos<  le32_to_cpu(rec.e_cpos));
> A same assert has already been performed inside ocfs2_get_clusters_nocache(),
> does it make sense to do it again here?

good catch

>> +
>> +		if ((!is_data&&  origin == SEEK_HOLE) ||
>> +		    (is_data&&  origin == SEEK_DATA)) {
>> +			if (extoff>  *offset)
>> +				*offset = extoff;
>> +			goto out_unlock;
> Seems above logic is going to stop at the first time we find a hole.
>
> How about the offset was within the range of a hole already when we doing
> SEEK_HOLE, shouldn't we proceed detecting until the next hole gets found, whose
> start_offset was greater than supplied offset, according to semantics described
> by the the header of this patch, should it be like following?
>
> 			if (extoff>  *offset) {
> 				*offset = extoff;
> 				goto out_unlock;
> 			}

So if the offset is in a hole, then we set the file pointer to it. Same for
data. The file pointer is set to the region asked at an offset that is equal
to or greater than the supplied offset.

>> +	if (origin == SEEK_HOLE) {
>> +		extoff = cpos;
>> +		extoff<<= cs_bits;
> extoff already has been assigned properly above in while loop?

To handle the case when supplied cpos == cend.

As always, excellent review.

Thanks
Sunil
