Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab0HYL6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 07:58:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:32808 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab0HYL6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 07:58:51 -0400
Message-ID: <4C750575.80109@suse.de>
Date: Wed, 25 Aug 2010 17:28:45 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Christopher K." <c.krooss@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: Automount causes zero-pointer dereference in 2.6.36-rc2
References: <AANLkTi=yQzDDHnX8HFrqCe8yqWuVA8b24zfPk5yZeWZk@mail.gmail.com>
In-Reply-To: <AANLkTi=yQzDDHnX8HFrqCe8yqWuVA8b24zfPk5yZeWZk@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 03:50 AM, Christopher K. wrote:
> Hi,
> I'm using autofs to mount some cifs shares in my /home.
> Running 2.6.36-rc2-git2, browsing /home results in the following error:
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<c124a921>] strncmp+0x11/0x30
> *pde = 00000000
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/virtual/bdi/cifs-5/uevent
> Modules linked in:
> Pid: 3496, comm: mount.cifs Not tainted 2.6.36-rc2-git2 #2 K50IJ
> EIP: 0060:[<c124921>] EFLAGS: 00010216 CPU: 1
> EIP is at strncmp+0x11/0x30
> EAX: 00000000 EBX: f3a5d200 ECX: 000001ff EDX: 00000000
> ESI: 00000000 EDI: 00000000 EBP: f3a98408 ESP: f3acde38
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process mount.cifs (pid: 3496, ti=f3acc000, task=f5adc800, task.ti=f3acc000)
> Stack:
>  f3a98400f5a24080 c119f122 00000000 00000000 00000000 00000000 00000000
> <0> 00003674 00000000 00000000 f3a7f02e f5a24080 c17d4320 f5a837c0 c119f784
> <0> c15c4280 f3acdea0 00000000 f3b2ae30 f3acdea4 f3b2ae00 00003673 f3b2ae30
> Call Trace:
> ...cifs_get_smb_ses...
> ...cifs_mount...
> ...kmem_cache_alloc...
> ...cifs_get_sb...
> ...vfs_kern_mount...
> ...get_fs_type...
> ...do_kern_mount...
> ...do_mount...
> ...copy_mount_options...
> ...sys_mount...
> ...sysenter_do_call...
> 

(Cc-ing linux-cifs@vger@kernel.org)

Does the following patch fixes the problem for you? This patch has been included
in the cifs development git and should be available in the next -rc.


Subject: [PATCH] cifs: check for NULL session password
From: Jeff Layton <jlayton@redhat.com>
Date: Mon, 23 Aug 2010 11:38:04 -0400
To: smfrench@gmail.com
CC: linux-cifs@vger.kernel.org

It's possible for a cifsSesInfo struct to have a NULL password, so we
need to check for that prior to running strncmp on it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 18af707..ec0ea4a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1673,6 +1673,7 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 				    MAX_USERNAME_SIZE))
 				continue;
 			if (strlen(vol->username) != 0 &&
+			    ses->password != NULL &&
 			    strncmp(ses->password,
 				    vol->password ? vol->password : "",
 				    MAX_PASSWORD_SIZE))


