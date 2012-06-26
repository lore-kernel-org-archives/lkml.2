Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400Ab2FZHh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:37:29 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39676 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab2FZHh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 03:37:27 -0400
Date: Tue, 26 Jun 2012 03:35:46 -0400
Message-ID: <20120626033546.Horde.D-JZIpir309P6WZSsiFCifA@imap.linux.ibm.com>
From: mc@linux.vnet.ibm.com
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Go through the LRU list of inode from head
References: <1340269227-20310-1-git-send-email-mc@linux.vnet.ibm.com>
 <20120621095223.GA11645@quack.suse.cz>
In-Reply-To: <20120621095223.GA11645@quack.suse.cz>
User-Agent: Internet Messaging Program (IMP) H4 (5.0.10)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062607-1780-0000-0000-000006D2C052
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000283; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000004; SDB=6.00151337; UDB=6.00034316; UTC=2012-06-26
 07:37:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quoting Jan Kara <jack@suse.cz>:

> On Thu 21-06-12 17:00:27, Cong Meng wrote:
>> Go through the LRU list of inode from head.
>>
>> (I'm not sure whether there is any trick here I doesn't get.  If yes,
>> any one could explain it)
>   Look at inode_lru_list_add(). It adds at the head of the list. So you
> should take from the tail to get the least recently used element...

I still have a quetion about the subsequent code and comment:

inode = list_entry(sb->s_inode_lru.prev, struct inode, i_lru);
/*
  * we are inverting the sb->s_inode_lru_lock/inode->i_lock here,
  * so use a trylock. If we fail to get the lock, just move the
  * inode to the back of the list so we don't spin on it.
  */
if (!spin_trylock(&inode->i_lock)) {
         list_move_tail(&inode->i_lru, &sb->s_inode_lru);
         continue;
}

Shouldn't the inode be moved to the head to avoid spin on it?
I note that list_move was replaced by list_move_tail purposely in a commit.


and below piece of code (at the bottom of prune_icache_sb()):

if (inode != list_entry(sb->s_inode_lru.next,
                         struct inode, i_lru))
         continue;       /* wrong inode or list_empty */

Should the inode be compared against to the tail of the list other  
than the head
after re-get the lru lock?

thanks.
cong.
>
> 								Honza
>
>>
>> Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
>> ---
>>  fs/inode.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/inode.c b/fs/inode.c
>> index 775cbab..aac8449 100644
>> --- a/fs/inode.c
>> +++ b/fs/inode.c
>> @@ -704,7 +704,7 @@ void prune_icache_sb(struct super_block *sb,  
>> int nr_to_scan)
>>  		if (list_empty(&sb->s_inode_lru))
>>  			break;
>>
>> -		inode = list_entry(sb->s_inode_lru.prev, struct inode, i_lru);
>> +		inode = list_entry(sb->s_inode_lru.next, struct inode, i_lru);
>>
>>  		/*
>>  		 * we are inverting the sb->s_inode_lru_lock/inode->i_lock here,
>> --
>> 1.7.5.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR



