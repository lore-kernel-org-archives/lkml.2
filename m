Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1JHMR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 08:17:29 -0400
Received: from gateway.alibaba-inc.com ([121.0.29.128]:47375 "EHLO
	CNHZ-ExGW-01.ali.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751802Ab1JHMR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 08:17:27 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Oct 2011 08:17:27 EDT
X-AuditID: 0a14034b-b7c6fae000005392-f4-4e903bd1e163
Subject: cgroup umount bug
From: =?UTF-8?Q?=E5=90=AB=E9=BB=9B?= <handai.szj@taobao.com>
Reply-To: <handai.szj@taobao.com>
To: <linux-kernel@vger.kernel.org>
CC: <paul@paulmenage.org>, <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Organization: taobao
Date: Sat, 8 Oct 2011 20:02:24 +0800
Message-ID: <1318075344.2168.4.camel@handai-OptiPlex-780>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.20.8.3]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

    I found a mount/umount problem while using cgroup: I mount a cpu
cgroup (or other subsystems) and create some subgroups under it, but
later I try to umount it without rmdir those subgroups. I find that I
can umount it without any errors but actually the super block still
exist. This is because the sb->s_active count is greater than 1 which
was added by cgroup_create. But later if I want to mount both cpu and
memory subsystems, it will be unsuccessful indicating that the
device(cpu subsystem) is busy. This situation will not happen if I rmdir
the subgroups manually before umount it. So my question is:
    Should the umount return success when there are still some subgroups
exist ? If this is okay, then it may lead to some *strange* errors using
cgroup later. If it can not be umount, then it should inform that the
mount point is still busy.


Following is an example of this problem:

mount -t cgroup -o cpu cgroup /mnt
mkdir /mnt/test

…..// do some tests

umount /mnt      /* return successfully */

/* do other subsystems test */
mount -cgroup -o cpu,cpuset cgroup /mnt
mount: cgroup already mounted or /mnt busy  /*??? which is strange */


Looking forward to your reply.
Thanks.


________________________________

This email (including any attachments) is confidential and may be legally privileged. If you received this email in error, please delete it immediately and do not copy it or use it for any purpose or disclose its contents to any other person. Thank you.

本电邮(包括任何附件)可能含有机密资料并受法律保护。如您不是正确的收件人，请您立即删除本邮件。请不要将本电邮进行复制并用作任何其他用途、或透露本邮件之内容。谢谢。
