Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab0ITHzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 03:55:39 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33653 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab0ITHzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 03:55:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>
Date: Mon, 20 Sep 2010 00:55:33 -0700
Message-ID: <m1aanc3l3e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
Subject: [PATCH 0/2] Fix mmap bugs with sysfs_remove_bin_file
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While reviewing the sysfs mmap code in fs/sysfs/bin.c I found two
rather nasty potential issues.

The first is if one of our wrapped mmap implementations implements
vma->close() we do not call it at sysfs_remove_bin_file time leading
to who knows what carnage.

The second is that we are potentially accessing the wrapped vm_ops
after sysfs_remove_bin_file has completed.   Which could be a problem
if it is a modular user.

I don't know of any real world instances of problems.  None of the
bin attribute mmaps functions that I know of today implement a close
method.  However it seems prudent to fix these now before we have
track down some mysterious weird failure with hotunplug.

Eric W. Biederman (2):
      sysfs: Fail bin file mmap if vma close is implemented.
      sysfs: only access bin file vm_ops with the active lock
---
 fs/sysfs/bin.c |   68 ++++++++++++++++++++++++++++----------------------------
 1 files changed, 34 insertions(+), 34 deletions(-)
