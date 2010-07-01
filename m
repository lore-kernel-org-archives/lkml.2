Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab0GAE5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 00:57:13 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:13254 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0GAE5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 00:57:11 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=XzOuK7UATF8A:10 a=hO-oPbc3tlwA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=0ZCBlT9FGNQ12LuOp84A:9
 a=kyQVXWv0L7enDBr6G7MA:7 a=adGBQQGxyfhnCsxAbFgFEq1Qj6MA:4 a=CjuIK1q_8ugA:10
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <30875.1277939713@redhat.com>
Date: Wed, 30 Jun 2010 22:57:07 -0600
Cc: viro@ZenIV.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <84225B35-7365-4DE2-8920-5741011B347C@dilger.ca>
References: <FB78A152-53D3-4000-ABDB-9D6051ECB887@dilger.ca> <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <26505.1277899544@redhat.com> <30875.1277939713@redhat.com>
To: David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-30, at 17:15, David Howells wrote:
> Andreas Dilger <adilger@dilger.ca> wrote:
>>> Passing -1 (or ULONGLONG_MAX) to get everything would be reasonable.
>> 
>> NOOOO.  That is exactly what we _don't_ want, since it makes it impossible
>> for the kernel to actually understand which fields the application is ready
>> to handle.  If the application always uses XSTAT_QUERY_ALL, instead of "-1",
>> then the kernel can easily tell which fields are present in the userspace
>> structure, and what it should avoid touching.
>> 
>> If applications start using "-1" to mean "all fields", then it will work so
>> long as the kernel and userspace agree on the size of struct xstat, but as
>> soon as the kernel understands some new field, but userspace does not, the
>> application will segfault or clobber random memory because the kernel thinks
>> it is asking for XSTAT_QUERY_NEXT_NEW_FIELD|... when it really isn't asking
>> for that at all.
> 
> As long as the field bits allocated in order and the extra results are tacked
> on in bit number order, will it actually be a problem?  Userspace must know how to deal with all the bits up to the last one it knows about; anything beyond that is irrelevant.

The patch you sent seems to get this right, but just for completeness, I'll answer in this thread.  Using the new struct as an example:

	#define XSTAT_REQUEST_GEN		0x00001000ULL
	#define XSTAT_REQUEST_DATA_VERSION	0x00002000ULL

        struct xstat {
                :
                :
		unsigned long long	st_data_version;
		unsigned long long	st_result_mask;
		unsigned long long	st_extra_results[0];
        }

An app "today" would allocate a struct xstat that ends at st_result_mask, and "today's" kernel will not know anything about flags beyond *_DATA_VERSION.  Even if today's app incorrectly uses request_mask = ~0ULL nothing will break until the kernel code changes.

If a future kernel gets a new static field at st_extra_results (say unsigned long long st_ino_high) with a new flag XSTAT_REQUEST_INO_HIGH 0x000040000ULL the kernel will think that the old app is requesting this field, and will fill in the 64-bit field at st_extra_results[1] (which the old app didn't allocate space for, nor does it understand) and may get a segfault, or stack smashing, or random heap corruption.

> What would you have me do?  Return an error if a request is made that the
> kernel doesn't support?  That's bad too.  This can be handled simply by
> clearing the result bit for any unsupported field.

I agree the desirable behaviour is if an app correctly sets request_mask at most to XSTAT_REQUEST__ALL_STATS 0x00003fffULL (or whatever it is at the time the app is compiled that matches the current struct xstat), and if the kernel understands e.g. XSTAT_REQUEST_INO_HIGH or not is irrelevant since the kernel will not touch fields that are not requested.  Likewise, if the application is compiled with a newer/larger XSTAT_REQUEST__ALL_STATS mask than what the kernel understands, the kernel will ignore the flags it doesn't understand.


Cheers, Andreas





