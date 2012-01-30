Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab2A3AUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 19:20:15 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:49689 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab2A3AUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 19:20:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org,
        Damien Millescamps <damien.millescamps@6wind.com>
Subject: Re: [PATCH 18/29] sysctl: Normalize the root_table data structure.
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
	<1327639925-12920-18-git-send-email-ebiederm@xmission.com>
	<CAPLs8y9-nA7gZymMkFzOdB6zh0h2hS+dhWu42ciOaHzJ++Z+gg@mail.gmail.com>
Date: Sun, 29 Jan 2012 16:22:49 -0800
In-Reply-To: <CAPLs8y9-nA7gZymMkFzOdB6zh0h2hS+dhWu42ciOaHzJ++Z+gg@mail.gmail.com>
	(Lucian Adrian Grijincu's message of "Sun, 29 Jan 2012 19:36:06
	+0200")
Message-ID: <m1pqe2jaxy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/TdZ626nc6BVjxOLENptqmkrZaq4t3Lzs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lucian thanks for the review.

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

> On Fri, Jan 27, 2012 at 6:51 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Every other directory has a .child member and we look at the .child
>> for our entries.  Do the same for the root_table.
>>
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>>  fs/proc/proc_sysctl.c |   15 +++++++++++----
>>  1 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
>> index 7e96a26..88d1b06 100644
>> --- a/fs/proc/proc_sysctl.c
>> +++ b/fs/proc/proc_sysctl.c
>> @@ -25,7 +25,14 @@ void proc_sys_poll_notify(struct ctl_table_poll *poll)
>>        wake_up_interruptible(&poll->wait);
>>  }
>>
>> -static struct ctl_table root_table[1];
>> +static struct ctl_table root_table[] = {
>> +       {
>> +               .procname = "",
>> +               .mode = S_IRUGO|S_IXUGO,
>
> Why not: .mode = S_IFDIR|S_IRUGO|S_IXUGO ?
>
> You change it later and add IFDIR in patch 22/29 because of this
> change (from 22/29):
> -	if (!table->child) {
> +	if (!S_ISDIR(table->mode)) {
>
> but if might as well be done here.

Actually doing not adding S_IFDIR here is important for keeping the
notion of changing one logical thing at a time.

I see normalizing this table early as deliberately emphasizing that we
started using S_IFDIR later.

>> +               .child = &root_table[1],
>> +       },
>> +       { }
>> +};
>>  static struct ctl_table_root sysctl_table_root;
>>  static struct ctl_table_header root_table_header = {
>>        {{.count = 1,
>> @@ -319,7 +326,7 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
>>                goto out;
>>        }
>
> Somewhere above we have
>   struct ctl_table *table = PROC_I(inode)->sysctl_entry;
> and sysctl_entry can take two values:
>    - NULL: fs/proc/inode.c:proc_alloc_inode()
>    - a non-NULL table in: proc_sys_make_inode()
>
> The only inode that can be passed to proc_sys_lookup that can have
> table=NULL is the root inode.
> In that case head will be &root_table_header.
>
>
> So head->ctl_table[1] == root_table_header.ctl_table[1] == root_table[1].

Yes.

>> -       table = table ? table->child : head->ctl_table;
>> +       table = table ? table->child : &head->ctl_table[1];
>
> I think this could be improved to something like this:
> /* table == NULL only for the procfs root directory */
> table = table ? table->child : &root_table[1];
>
>
> It's not that important, as this code will go away in a few patches.

Good catch.  I had to ask myself after I read this why the code wasn't
pointing at root_table already.  The answer as it turns out was because
it was static in kernel/sysctl.c until my earlier patches and I simply
missed the opportunity.

>>        p = find_in_table(table, name);
>>        if (!p) {
>> @@ -510,7 +517,7 @@ static int proc_sys_readdir(struct file *filp, void *dirent, filldir_t filldir)
>>                goto out;
>>        }
>>
>> -       table = table ? table->child : head->ctl_table;
>> +       table = table ? table->child : &head->ctl_table[1];
>
> Similar.

Agreed.  At this point in the game since this code does go away I don't
think it is worth making the change now. But I will keep it in mind
and I you have definitely spotted an opportunity missed in this
patchset.

Eric
