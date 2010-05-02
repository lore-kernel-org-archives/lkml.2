Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab0EBEzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 00:55:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54598 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab0EBEzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 00:55:38 -0400
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Benjamin Thery <benjamin.thery@bull.net>,
       NeilBrown <neilb@suse.de>
References: <20100430155205.a4171034.sfr@canb.auug.org.au>
	<20100501174853.GA22217@kroah.com>
From: ebiederm@xmission.com.z (Eric W. Biederman)
Date: Sat, 01 May 2010 21:55:29 -0700
In-Reply-To: <20100501174853.GA22217@kroah.com> (Greg KH's message of "Sat\, 1 May 2010 10\:48\:53 -0700")
Message-ID: <m1sk6a9a2m.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: greg@kroah.com, neilb@suse.de, benjamin.thery@bull.net, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, sfr@canb.auug.org.au
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: linux-next: build failure after merge of the staging-next tree
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Fri, Apr 30, 2010 at 03:52:05PM +1000, Stephen Rothwell wrote:
>> Hi Greg,
>> 
>> After merging the staging-next tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>> 
>> drivers/md/md.c: In function 'level_store':
>> drivers/md/md.c:3029: error: too few arguments to function 'sysfs_get_dirent'
>> 
>> Caused by commit 262f8e4937e7b4a587923ca3c039a184668f49ec ("sysfs:
>> Implement sysfs tagged directory support") from the driver-core tree
>> interacting with commit fecc531e3cc0de60514d326c7d82f1075ed55888 ("md:
>> manage redundancy group in sysfs when changing level") from the md.
>> 
>> I have applied this fixup patch for today and can carry it as necessary.
>
> Thanks, that would be great.
>
>> [This could have been avoided, of course, by creating a new API (maybe
>> sysfs_get_dirent_tagged) and implementing the old API in terms of that].
>
> Hm Eric, any thoughts?

I believe I touched all of the users of sysfs_get_dirent outside of sysfs
that existed when I sent you the patch.

Right now using sysfs_get_dirent is a hack to support notifications of
changes to sysfs files from atomic contexts, where sysfs_notify is
unsafe because it sleeps on sysfs_mutex.  There are maybe 5 callers of
sysfs_get_dirent outside of sysfs.  Given that we have a nice compile
time error I don't think it makes sense to have multiple versions of the
function.

It will probably makes sense at some point to go through and push
everything to using a less hacky solution, but for the moment the
solution is correct and doesn't cause too much pain so I'm not too
worried about it.

As for the fixup patch itself it looked correct.

Eric
