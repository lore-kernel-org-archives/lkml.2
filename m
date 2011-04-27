Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459Ab1D0PxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:53:03 -0400
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:40195 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759396Ab1D0PxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:53:00 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: G0ziTisVM1mwyWzHJBoN56bKoG2jT4T3SaK1hzTR57PV1kK
 2l_m1tW_WeU3vURcwlBPL1EdhojdnGjupZ3Z89aMm8TEV6_u2gXsD.6gz0M4
 WJHxbVJwHRxWo3n1lrSs3GHhuCWO6obmj7It4iYZ_vTQG_57hV0yPphVav3t
 R0ASLiAvelrt.yJ1NimRFKpmYclQC88GT2ySW8yxvNtSRwPodH2u7gsQwZFy
 8fDJ5Ja9GEb6ykp9bARfwHmyWD_7YARwvDMLuxKMWXkAMrgnDP1DfceNcMQh
 of4uLhsXWGMF9mWnIYdUCmpwldevFX7P_OeFPqXDheIxlhujPLDoshPusddo
 K0l_AvRnTcb3Sl6WSnRvZWjaLYRtOU2bfKA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DB83BDB.8080301@schaufler-ca.com>
Date: Wed, 27 Apr 2011 08:52:59 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Roberto Sassu <roberto.sassu@polito.it>
CC: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        ecryptfs-devel@lists.launchpad.net, eparis@redhat.com,
        sds@tycho.nsa.gov, selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk
Subject: Re: [RFC][PATCH 0/7] File descriptor labeling
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it>
In-Reply-To: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/2011 5:34 AM, Roberto Sassu wrote:
> File descriptor labeling issue
>
> Actually SELinux and SMACK assign to file descriptors the same label of the
> opening process and use it in LSM hooks security_file_permission(),
> security_file_fcntl() and others to verify if the 'current' process has the
> rights to perform the requested operation.
>
> Using the credentials of the 'current' process may be not appropriate in
> case a file descriptor is opened by a kernel service (i.e. a filesystem)
> and made shared among user processes. For instance, in a system with
> SELinux and eCryptfs, if the process A opens an encrypted file, eCryptfs
> obtains a file descriptor to access the correspondent inode in the lower
> filesystem, labeled with the A's label.
>
> If the process B accesses the same encrypted file, it needs the 'use'
> permission on the A's label other than permissions for the lower inode.
> However, if B is the first accessing process, A needs the 'use' permission
> on the B's label.
>
> The solution proposed is to modify those kernel services that deal with
> file descriptors to provide their set of credentials to dentry_open(), so
> that obtained objects are labeled with a unique label. In this way, in the
> above example, if eCryptfs provides its credentials with the label C to
> dentry_open(), all user processes need the 'use' permission only on C.
>
>
>
> File descriptor labeling and IMA
>
> The above proposal suggests to use the file descriptor label as a new
> criteria in the IMA policy to determine if a file must be measured. It will
> be possible to measure all files opened by a kernel service by simply
> writing a rule where the file descriptor label given as a value matches the
> one provided by the same service together with other credentials to the
> function dentry_open().
>
> In the above example, if eCryptfs provides its credentials with the label C
> to dentry_open(), it is possible to measure all inodes opened in the lower
> filesystem by specifying a rule like:
>
> fowner_type=C
>
>
> The benefits of this new criteria will be greater with the integration of
> EVM and the IMA appraisal feature in the kernel. ECryptfs can be used in
> conjunction with these components to verify the integrity of the content
> and extended attributes of encrypted files.
>
> Roberto Sassu
>
>
> Roberto Sassu (7):
>   fs: initialize file->f_cred with credentials provided
>   selinux: label new file descriptors using file->f_cred
>   smack: assign the label set in file->f_cred to new file descriptors
>   smack: fix label check in smack_kernel_act_as()
>   smack: import the security label in smack_secctx_to_secid()
>   security: new LSM hook security_file_getsecid()
>   ima: added new LSM conditions in the policy
>
>  Documentation/ABI/testing/ima_policy |    7 ++++-
>  fs/file_table.c                      |    5 +--
>  fs/internal.h                        |    2 +-
>  fs/namei.c                           |    2 +-
>  fs/open.c                            |    2 +-
>  include/linux/security.h             |   12 +++++++++
>  security/capability.c                |    6 ++++
>  security/integrity/ima/ima.h         |    4 +-
>  security/integrity/ima/ima_api.c     |    4 +-
>  security/integrity/ima/ima_main.c    |    4 +-
>  security/integrity/ima/ima_policy.c  |   45 +++++++++++++++++++++++++++++----
>  security/security.c                  |    6 ++++
>  security/selinux/hooks.c             |    9 ++++++-
>  security/smack/smack_lsm.c           |   23 +++++++++++++++--
>  14 files changed, 108 insertions(+), 23 deletions(-)

I have not given this patch set a complete review, but at first
glance I do not like it. You seem to be making a lot of assumptions
about the interactions between services and LSMs that I don't
know are valid. It is possible that I have not dug in deeply
enough to understand where this is headed. I will have a more
complete review in a bit.

