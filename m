Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab1B1P7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:59:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37630 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1B1P7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:59:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pXoi+MFWXXJe9HPRro5tQr7FTNVwm7cntDqRWGWFYVaN5vusf+I6b//vcjDUQUudKy
         0AoN4ldu/HHGzU8jyD0gvWbLuixtvJ9fB6kUQWLJ+FoyK4KJZ7RjxTjKdl8OM9rwaH28
         F8j0dc90te9UxonDmQdq7vZX/l8SpXUMJhVHA=
Message-ID: <4D6BC666.4010603@gmail.com>
Date: Mon, 28 Feb 2011 16:59:34 +0100
From: "=?ISO-8859-15?Q?Andreas_Bie=DFmann?=" <andreas.devel@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: =?ISO-8859-15?Q?Andreas_Bie=DFmann?= <biessmann@corscience.de>,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs-writeback: fix NULL pointer dereference in __mark_inode_dirty
References: <1298906733-31427-1-git-send-email-biessmann@corscience.de> <20110228154314.GA4675@swordfish.minsk.epam.com>
In-Reply-To: <20110228154314.GA4675@swordfish.minsk.epam.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sergey Senozhatsky,

Am 28.02.2011 16:43, schrieb Sergey Senozhatsky:
> On (02/28/11 16:25), Andreas Bieﬂmann wrote:

>> The reference to sb->s_bdi may be deleted from mmc_blk_remove() ->
>> del_gendisk() -> unlink_gendisk() -> bdi_unregister() -> bdi_prune_sb() while
>> another instance try to write some data to the device.
>>
>> Signed-off-by: Andreas Bieﬂmann <biessmann@corscience.de>
>> ---
>>  fs/fs-writeback.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
>> index cdbf7ac..96b4b25 100644
>> --- a/fs/fs-writeback.c
>> +++ b/fs/fs-writeback.c
>> @@ -1047,6 +1047,9 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>>  		if (!was_dirty) {
>>  			bdi = inode_to_bdi(inode);
>>  
>> +			if (!bdi)
>> +				goto out;
>> +
>>  			if (bdi_cap_writeback_dirty(bdi)) {
>>  				WARN(!test_bit(BDI_registered, &bdi->state),
>>  				     "bdi-%s not registered\n", bdi->name);
> 
> Hello,
> I had something very similar to this some time ago
> https://lkml.org/lkml/2010/12/9/436

Sorry, I did not see that patch.

> However, I'm not sure that this check is sufficient.

Why are you think this is not sufficient?
If an instance try to write that specific inode to an physical device
which is not longer available how should we react then?

Another solution could be to clean up all instances referring to that
superblock in del_/unlink_gendisk(). But I think to check the return of
inode_to_bdi() is needed in any case.

regards

Andreas Bieﬂmann
