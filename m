Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab2IWF7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 01:59:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52538 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2IWF7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 01:59:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, sukadev@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>
References: <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
	<20120124010758.GJ23916@ZenIV.linux.org.uk>
	<m1k44gj1cu.fsf@fess.ebiederm.org> <20120124220247.GA26353@hallyn.com>
	<CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
	<20120124231601.GA4470@sergelap>
	<CAPXgP12REAwmDORzdGJhsxZKU8nhiauCxoVdKa8Eifw4MWWtgA@mail.gmail.com>
	<20120128195103.GA11299@sergelap> <87txup763i.fsf_-_@xmission.com>
	<87d31d75yj.fsf_-_@xmission.com>
	<20120923041906.GM13973@ZenIV.linux.org.uk>
Date: Sat, 22 Sep 2012 22:59:04 -0700
In-Reply-To: <20120923041906.GM13973@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 23 Sep 2012 05:19:06 +0100")
Message-ID: <87bogx5lg7.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/jHs81MdSkri+ehlOuCK3+SJkRgTV8qSk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 3/4] devpts: Make the newinstance option historical
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sat, Sep 22, 2012 at 08:50:44PM -0700, Eric W. Biederman wrote:
>
>> +struct inode *devpts_redirect(struct file *filp)
>> +{
>> +	struct inode *inode;
>> +	struct file *filp2;
>> +
>> +	/* Is the inode already a devpts inode? */
>> +	inode = filp->f_dentry->d_inode;
>> +	if (filp->f_dentry->d_sb->s_magic == DEVPTS_SUPER_MAGIC)
>> +		goto out;
>> +
>> +	/* Is f_dentry->d_parent usable? */
>> +	inode = ERR_PTR(-ENODEV);
>> +	if (filp->f_vfsmnt->mnt_root == filp->f_dentry)
>> +		goto out;
>> +
>> +	/* Is there a devpts inode we can use instead? */
>> +	
>> +	filp2 = file_open_root(filp->f_dentry->d_parent, filp->f_vfsmnt,
>> +			       "pts/ptmx", O_PATH);
>> +	if (!IS_ERR(filp2)) {
>> +		if (filp2->f_dentry->d_sb->s_magic == DEVPTS_SUPER_MAGIC) {
>> +			struct path old;
>> +			old = filp->f_path;
>> +			filp->f_path = filp2->f_path;
>> +			inode = filp->f_dentry->d_inode;
>> +			path_get(&filp->f_path);
>> +			path_put(&old);
>
> You are welcome to supply an analysis of the reasons why ->open() pulling
> such tricks will not break all kinds of code in VFS.


>> +		}
>> +		fput(filp2);
>
> ... starting with "what happens when some joker binds /dev/ptmx on
> /dev/pts/ptmx"

The test:
>> +	if (filp->f_vfsmnt->mnt_root == filp->f_dentry)
kicks in and no redirection is performed.


> Or does mknod /tmp/ptmx c 5 2; mkdir /tmp/pts; ln /tmp/ptmx /tmp/pts/ptmx,
> for that matter...

The test:
>> +		if (filp2->f_dentry->d_sb->s_magic == DEVPTS_SUPER_MAGIC) {n
fails and no redirection is performed.

> NAK.  This violates asserts made by VFS (namely, that ->f_path is not
> changed since dentry_open() has set it and until __fput() rips the thing
> out) *and* by your own code (attack mentioned above, just from looking
> at it for a minute).  Far too brittle...

This code seems much more robust than your quick analysis.

But if the constraint that the path in struct file must not be
changed between dentry_open and __fput that is doable to it just
needs a little more reorganizing of the data structures.  It is
definitely not a fundamental limitation.

Eric





