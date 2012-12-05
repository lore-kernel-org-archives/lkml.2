Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2LEF6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 00:58:43 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57871 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2LEF6k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 00:58:40 -0500
MIME-Version: 1.0
In-Reply-To: <87obia17zr.fsf@devron.myhome.or.jp>
References: <1353504277-5947-1-git-send-email-linkinjeon@gmail.com>
	<87hao35uqz.fsf@devron.myhome.or.jp>
	<CAKYAXd_X8Jkq=PdV+dVPTO_EAPHoZ37MynpjvkrPTDahWyUOTA@mail.gmail.com>
	<87obia17zr.fsf@devron.myhome.or.jp>
Date: Wed, 5 Dec 2012 14:58:39 +0900
Message-ID: <CAKYAXd-8ay4m6vsH1ztmomOrnXN+ThDi3w+jASyyUGOO12v6YA@mail.gmail.com>
Subject: Re: [PATCH v5 5/8] fat: restructure export_operations
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/4, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>> +static struct dentry *fat_fh_to_dentry_nostale(struct super_block *sb,
>>>> +					       struct fid *fh, int fh_len,
>>>> +					       int fh_type)
>>>> +{
>>>> +	struct inode *inode = NULL;
>>>> +	struct fat_fid *fid = (struct fat_fid *)fh;
>>>> +	loff_t i_pos;
>>>> +
>>>> +	switch (fh_type) {
>>>> +	case FILEID_FAT_WITHOUT_PARENT:
>>>> +		if (fh_len < FAT_FID_SIZE_WITHOUT_PARENT)
>>>> +			return NULL;
>>>> +	case FILEID_FAT_WITH_PARENT:
>>>> +		if ((fh_len < FAT_FID_SIZE_WITH_PARENT) &&
>>>> +			(fh_type == FILEID_FAT_WITH_PARENT))
>>>> +			return NULL;
>>>
>>> Do we have to care (FILEID_FAT_WITH_PARENT and fh_len < 5) here?
>>>
>>> 	if (fh_len < 2)
>>> 		return NULL;
>>>
>>> 	switch (fh_type) {
>>> 	case FILEID_INO32_GEN:
>>> 	case FILEID_INO32_GEN_PARENT:
>>> 		inode = get_inode(sb, fid->i32.ino, fid->i32.gen);
>>> 		break;
>>> 	}
>>>
>>> 	return d_obtain_alias(inode);
>>>
>>> generic_fh_to_dentry() is above. I wonder why we have to care
>>> fat_fid->parent* here.
>> Let me think, if ‘subtree’ checking is enabled then we should check
>> the length condition over here also? Please share if there are any
>> other comments also.
>
> I'm not sure what did you mean. Where is "subtree" check you are
> talking? This is fh_to_dentry(), so we don't use parent at all, so
> length == 3 is enough?
With fileID type="FILEID_FAT_WITHOUT_PARENT", fhlen  should be '3'
With fileId type="FILEID_FAT_WITH_PARENT", fhlen should be '5'

While encoding, WITH_PARENT is selected when subtree check is enabled
on the NFS Server.

So, when decoding request is arrived-  fileid type will be among the '2' cases:
Now, in case of fh_to_dentry() - when we consider, that the reqquest
for fileid type WITH_PARENT
then i think the conditions in fh_to_dentry should be:

if((fh_type == FILEID_FAT_WITH_PARENT) && fh_len != 5)
	return NULL;
else if (fh_len != 3)
	return NULL;

So, we took care of these '2' conditions within the switch statement
based on the 'fh_type'. We can just change the comparision condition
from '<' to '!=':
switch (fh_type) {
+	case FILEID_FAT_WITHOUT_PARENT:
+		if (fh_len != FAT_FID_SIZE_WITHOUT_PARENT)
+			return NULL;
+	case FILEID_FAT_WITH_PARENT:
+		if ((fh_len != FAT_FID_SIZE_WITH_PARENT) &&
+			(fh_type == FILEID_FAT_WITH_PARENT))
+			return NULL;
+		i_pos = fid->i_pos_hi;
+		i_pos = (i_pos << 32) | (fid->i_pos_low);
+		inode = __fat_nfs_get_inode(sb, 0, fid->i_gen, i_pos);
+		break;
+	}

I think there is no need to push the comparision statements in the
begining similar to generic_fh_to_dentry.

Thanks OGAWA.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
