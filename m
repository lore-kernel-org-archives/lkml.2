Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2HPICU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:02:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48606 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612Ab2HPICN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:02:13 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1345045700-9062-9-git-send-email-miklos@szeredi.hu>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
	<1345045700-9062-9-git-send-email-miklos@szeredi.hu>
Date: Thu, 16 Aug 2012 10:02:11 +0200
Message-ID: <CA+icZUX32x5qiyxhAakxvo0Y4ypEA=DiurP5WCxbYmFi07+O4A@mail.gmail.com>
Subject: Re: [PATCH 08/13] fs: limit filesystem stacking depth
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, goran.cetusic@gmail.com, romain@orebokech.com,
        mszeredi@suse.cz
Content-Type: multipart/mixed; boundary=90e6ba1821c0f5775204c75d7598
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba1821c0f5775204c75d7598
Content-Type: text/plain; charset=UTF-8

On Wed, Aug 15, 2012 at 5:48 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Add a simple read-only counter to super_block that indicates deep this
> is in the stack of filesystems.  Previously ecryptfs was the only
> stackable filesystem and it explicitly disallowed multiple layers of
> itself.
>
> Overlayfs, however, can be stacked recursively and also may be stacked
> on top of ecryptfs or vice versa.
>
> To limit the kernel stack usage we must limit the depth of the
> filesystem stack.  Initially the limit is set to 2.
>

Hi,

I have tested OverlayFS for a long time with "fs-stack-depth=3".
The original OverlayFS test-case script  from Jordi was slightly
modified (see "testcase-ovl-v3.sh").
I have sent my test-results to Andy and Jordi (tested with the
patchset from Andy against Linux-v3.4 [1] with Ext4-FS).
The attached test-case script *requires* "fs-stack-depth=3" to run
properly (patch attached).

So, I have 2 questions:

[1] FS-stack-limitation

Is a "fs-stack-depth>=2" (like "3") critical?
Is your setting to "2" just a defensive (and initial) one?
Can you explain your choice a bit more as ecryptFS is involved in this
limitation, too.

[2] Test-Case/Use-Case scripts

It would be *very very very* helpful if you could provide or even ship
in the Linux-kernel a test-case/use-case script, Thanks!
Maybe describe "Documentation/filesystems/overlayfs.txt" would be a good place?
Helpful could be a "simple" and a "complex" testing scenario?

- Sedat -


[1] http://git.kernel.org/?p=linux/kernel/git/apw/overlayfs.git;a=shortlog;h=refs/heads/overlayfs.v12apw1

> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/ecryptfs/main.c   |    7 +++++++
>  fs/overlayfs/super.c |   10 ++++++++++
>  include/linux/fs.h   |   11 +++++++++++
>  3 files changed, 28 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index 2768138..344fb2c 100644
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@ -565,6 +565,13 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
>         s->s_maxbytes = path.dentry->d_sb->s_maxbytes;
>         s->s_blocksize = path.dentry->d_sb->s_blocksize;
>         s->s_magic = ECRYPTFS_SUPER_MAGIC;
> +       s->s_stack_depth = path.dentry->d_sb->s_stack_depth + 1;
> +
> +       rc = -EINVAL;
> +       if (s->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
> +               printk(KERN_ERR "eCryptfs: maximum fs stacking depth exceeded\n");
> +               goto out_free;
> +       }
>
>         inode = ecryptfs_get_inode(path.dentry->d_inode, s);
>         rc = PTR_ERR(inode);
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 69a2099..64d2695 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -551,6 +551,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>             !S_ISDIR(lowerpath.dentry->d_inode->i_mode))
>                 goto out_put_lowerpath;
>
> +       sb->s_stack_depth = max(upperpath.mnt->mnt_sb->s_stack_depth,
> +                               lowerpath.mnt->mnt_sb->s_stack_depth) + 1;
> +
> +       err = -EINVAL;
> +       if (sb->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
> +               printk(KERN_ERR "overlayfs: maximum fs stacking depth exceeded\n");
> +               goto out_put_lowerpath;
> +       }
> +
> +
>         ufs->upper_mnt = clone_private_mount(&upperpath);
>         err = PTR_ERR(ufs->upper_mnt);
>         if (IS_ERR(ufs->upper_mnt)) {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index abc7a53..1265e24 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -505,6 +505,12 @@ struct iattr {
>   */
>  #include <linux/quota.h>
>
> +/*
> + * Maximum number of layers of fs stack.  Needs to be limited to
> + * prevent kernel stack overflow
> + */
> +#define FILESYSTEM_MAX_STACK_DEPTH 2
> +
>  /**
>   * enum positive_aop_returns - aop return codes with specific semantics
>   *
> @@ -1579,6 +1585,11 @@ struct super_block {
>
>         /* Being remounted read-only */
>         int s_readonly_remount;
> +
> +       /*
> +        * Indicates how deep in a filesystem stack this SB is
> +        */
> +       int s_stack_depth;
>  };
>
>  /* superblock cache pruning functions */
> --
> 1.7.7
>

--90e6ba1821c0f5775204c75d7598
Content-Type: application/x-sh; name="testcase-ovl-v3.sh"
Content-Disposition: attachment; filename="testcase-ovl-v3.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h5xjqlqp0

IyEvYmluL3NoCgojIFRlc3RjYXNlIGZvciBPdmVybGF5IEZpbGVTeXN0ZW0gKE92ZXJsYXlGUyBv
ciBzaG9ydDogb3ZsKQojCiMgT3JpZ2luYWwgVGVzdGNhc2U6IGh0dHA6Ly9saXZlbmV0LnNlbGZp
cC5jb20vZnRwL2RlYmlhbi9vdmVybGF5ZnMvdGVzdC90ZXN0MDYuc2gKIyAgIE9yaWdpbmFsIEF1
dGhvcjogSm9yZGkgUHVqb2wgPGpvcmRpcHVqb2xwQGdtYWlsLmNvbT4KIwojIFNsaWdodGx5IG1v
ZGlmaWVkOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgojCiogMzAtQXByLTIw
MTI6IHYzCiMgKiBSZXRlc3RlZCB3aXRoIE92ZXJsYXlGUyB2MTIgYWdhaW5zdCBMaW51eC0zLjQt
cmM1CiMgKiBQYXRjaGVzOiAxLiBvdmwtcGF0Y2ggKE9wZW5XcnQpIDIuIG15IGluY2x1ZGUtZml4
IDMuIG15IHRvdWNoX2F0aW1lLWZpeCA0LiBkX21ha2Vfcm9vdC1maXggZnJvbSBxdWFudGFsIChi
eSBhcHcpCiMgKiBhcHcgYXNrZWQgZm9yIGluY2x1c2lvbiBvZiBteSAiZnM6IEluY3JlYXNlIGxp
bWl0IGZpbGVzeXN0ZW0gc3RhY2tpbmcgZGVwdGggdG8gMyIgcGF0Y2gKIyAgIChkbWVzZzogWyAg
NDc2LjcwOTQxOF0gb3ZlcmxheWZzOiBtYXhpbXVtIGZzIHN0YWNraW5nIGRlcHRoIGV4Y2VlZGVk
KQojIDI5LUFwci0yMDEyOiB2MgojICogUmV0ZXN0ZWQgd2l0aCBPdmVybGF5RlMgdjEyIGFnYWlu
c3QgTGludXgtMy4zLjQKIyAyMi1KdWwtMjAxMTogdjEKIyAqIEZpcnN0IHRlc3RzIHdpdGggT3Zl
cmxheUZTIHYxMCBvbiB0b3Agb2YgdmZzLW5leHQgd2l0aCBsaW51eC1uZXh0IChuZXh0LTIwMTEw
NzIyKQojICAgKFJlcXVpcmVzICJmczogSW5jcmVhc2UgbGltaXQgZmlsZXN5c3RlbSBzdGFja2lu
ZyBkZXB0aCB0byAzIiBwYXRjaCkKIyAKCnNldCAteApzZXQgLWUKCmV4cG9ydCBMQU5HPUMKZXhw
b3J0IExDX0FMTD1DCgpCQVNFX0RJUj0kKHB3ZCkKVEVNUF9ESVI9IiR7QkFTRV9ESVJ9L3RtcCIK
CktWRVI9JCh1bmFtZSAtcikKCkZTX1RZUEU9ImV4dDQiCkZTX09QVFM9Ii1GIC1xIgoKTUtGU19C
SU49Im1rZnMuJHtGU19UWVBFfSIKCiMgTG9hZCBsb29wIGFuZCBvdmVybGF5ZnMga2VybmVsLW1v
ZHVsZXMKbW9kcHJvYmUgLXYgbG9vcAptb2Rwcm9iZSAtdiBvdmVybGF5ZnMKCiMgZmlsZSBvciBk
aXIgbW9kZSwgY29tcHV0ZWQgd2l0aCBjdXJyZW50IHVtYXNrCiMgcGFyYW06IGxlc3MgcmVzdHJp
Y3RpdmUgbW9kZQpfbW9kZSgpIHsKCXByaW50ZiAiJSNvIiAkKCgwJHsxfSAmIH4wJCh1bWFzaykp
KQp9CgojIGNyZWF0ZSBhIHRlbXBvcmFyeSBmaWxlCiMgcGFyYW06IGRpcmVjdG9yeQojIHBhcmFt
OiBmaWxlIG5hbWUKX21rdGVtcCgpIHsKCWxvY2FsIGQKCWQ9IiQobWt0ZW1wIC1wICIkezF9IiAk
ezI6KyIkezJ9LVhYWCJ9KSIgfHwgcmV0dXJuIDEKCWNobW9kICQoX21vZGUgIjA2NjYiKSAiJHtk
fSIKCWVjaG8gIiR7ZH0iCn0KCiMgY3JlYXRlIGEgdGVtcG9yYXJ5IGRpcmVjdG9yeQojIHBhcmFt
OiBkaXJlY3RvcnkKIyBwYXJhbTogZGlyZWN0b3J5IG5hbWUKX21rdGVtcGRpcigpIHsKCWxvY2Fs
IGQKCWQ9IiQobWt0ZW1wIC1kIC1wICIkezF9IiAkezI6KyIkezJ9LVhYWCJ9KSIgfHwgcmV0dXJu
IDEKCWNobW9kICQoX21vZGUgIjA3NzciKSAiJHtkfSIKCWVjaG8gIiR7ZH0iCn0KCl9zYW1wbGVf
ZGF0YSgpIHsKCWxvY2FsIHA9IiR7MX0iCglsb2NhbCBsPSIkKF9ta3RlbXBkaXIgIiR7V09SS19E
SVJ9IiAiV09SSyIpIgoJbG9jYWwgZD0iJHtsfSR7cH0iCglsb2NhbCBmCgkoIG1rZGlyIC1wICIk
e2R9IgoJZWNobyAiYSIgPiAiJChfbWt0ZW1wICIke2R9IiAiVEVYVCIpIgoJZWNobyAiYSIgPiAi
JChfbWt0ZW1wICIke2R9IiAiVEVYVCIpIgoJZWNobyAiYSIgPiAiJChfbWt0ZW1wICIke2R9IiAi
VEVYVCIpIgoJZj0iJChfbWt0ZW1wICIke2R9IiAiRVhFQyIpIgoJZWNobyAiIy9iaW4vc2gKZWNo
byAnZXhlY3V0ZWQnCjoiID4gIiR7Zn0iCgljaG1vZCAkKF9tb2RlICIwNzc3IikgIiR7Zn0iCglt
a3NxdWFzaGZzICIke2x9IiAiJHtsfS5zcXVhc2hmcyIgLWIgMU0KCXJtIC1yZiAiJHtsfSIgKSA+
JjIKCWVjaG8gIiR7bH0uc3F1YXNoZnMiCn0KCl9vdmVybGF5ZnNfdGVzdCgpIHsKCWxvY2FsIGQ9
IiR7MX0iCglsb2NhbCByYz0iMCIKCWxvY2FsIGYgZyBpCgoJbHMgLWxhICIke2R9IgoKCWk9MAoJ
Zz0iJHtkfSIKCXdoaWxlIFsgJHtpfSAtbHQgMyBdOyBkbwoJCWlmIGc9IiQoX21rdGVtcGRpciAi
JHtnfSIgIlRNUERJUiIpIjsgdGhlbgoJCQlfbWt0ZW1wICIke2d9IiAiVE1QRklMRSIKCQkJaT0k
KCgke2l9KzEpKQoJCQlybSAke2d9LyoKCQllbHNlCgkJCWJyZWFrCgkJZmkKCWRvbmUKCglmb3Ig
ZiBpbiAkKGZpbmQgIiR7ZH0iIC10eXBlIGYpOyBkbwoJCXNlZCAtaSAtZSAnc3xhfCZiXG4mJnxn
JyAiJHtmfSIgfHwgcmM9IjEiCglkb25lCgoJZm9yIGYgaW4gJChmaW5kICIke2R9IiAtdHlwZSBm
IC1uYW1lICdFWEVDKicpOyBkbwoJCSIke2Z9IiB8fCBlY2hvICJub3QgZXhlY3V0ZWQiCglkb25l
CgoJaWYgWyAiJHtyY30iICE9ICIwIiBdOyB0aGVuCgkJZm9yIGYgaW4gJChmaW5kICIke2R9IiAt
dHlwZSBmKTsgZG8KCQkJdG91Y2ggIiR7Zn0iIHx8IDoKCQlkb25lCgoJCWZvciBmIGluICQoZmlu
ZCAiJHtkfSIgLXR5cGUgZik7IGRvCgkJCXNlZCAtaSAtZSAnc3xhfGF8ZycgIiR7Zn0iIHx8IDoK
CQlkb25lCglmaQoKCWZvciBmIGluICQoZmluZCAiJHtkfSIgLXR5cGUgZik7IGRvCgkJY2F0ICIk
e2Z9IgoJCWVjaG8gIi0tLS0tLS0tIgoJZG9uZQp9CgpfdGVzdCgpIHsKCV9vdmVybGF5ZnNfdGVz
dCAiJHtST09UX0RJUn0vZXRjL2FwYWNoZTIiCgoJX292ZXJsYXlmc190ZXN0ICIke1JPT1RfRElS
fS9ib290L2dydWIiCgoJX292ZXJsYXlmc190ZXN0ICIke1JPT1RfRElSfS9ldGMvZGVmYXVsdCIK
fQoKWyAtZCAke1RFTVBfRElSfSBdIHx8IG1rZGlyIC1wICR7VEVNUF9ESVJ9CgpXT1JLX0RJUj0i
JChfbWt0ZW1wZGlyICIke1RFTVBfRElSfSIgIlRFU1QtJHtLVkVSfSIpIgoKTE9HPSIkKF9ta3Rl
bXAgIiR7V09SS19ESVJ9IiAiTE9HIikiCmV4ZWMgPiAiJHtMT0d9IiAyPiYxCgpMT1dFUjFfRElS
PSIkKF9zYW1wbGVfZGF0YSAiL2V0Yy9kZWZhdWx0IikiCkxPV0VSMl9ESVI9IiQoX3NhbXBsZV9k
YXRhICIvYm9vdC9ncnViIikiCkxPV0VSM19ESVI9IiQoX3NhbXBsZV9kYXRhICIvZXRjL2FwYWNo
ZTIiKSIKCnVuc2V0IHVmIGxmCndoaWxlIHJlYWQgdWY7IGRvCglbIC1lICIke3VmfSIgXSB8fCBc
CgkJY29udGludWUKCglpZiBbIC1kICIke3VmfSIgXTsgdGhlbgoJCXU9IiR7dWZ9IgoJZWxzZQoJ
CXU9IiQoX21rdGVtcGRpciAiJHtXT1JLX0RJUn0iICJVUFBFUiIpIgoJCW1vdW50IC1vIGxvb3As
cm8gIiR7dWZ9IiAiJHt1fSIKCWZpCgoJaWYgWyAtbiAiJHtsZn0iIF07IHRoZW4KCQlpZiBbIC1k
ICIke2xmfSIgXTsgdGhlbgoJCQlsPSIke2xmfSIKCQllbHNlCgkJCWw9IiQoX21rdGVtcGRpciAi
JHtXT1JLX0RJUn0iICJMT1dFUiIpIgoJCQltb3VudCAtbyBsb29wLHJvICIke2xmfSIgIiR7bH0i
CgkJZmkKCgkJcj0iJChfbWt0ZW1wZGlyICIke1dPUktfRElSfSIgIlJPT1QtUk8iKSIKCgkJbW91
bnQgLXQgb3ZlcmxheWZzIC1vIHJvLGxvd2VyZGlyPSIke2x9Iix1cHBlcmRpcj0iJHt1fSIgIm92
ZXJsYXlmcyIgIiR7cn0iCgoJCWxmPSIke3J9IgoJZWxzZQoJCWxmPSIke3V9IgoJZmkKZG9uZSA8
PCBFT0YKJHtMT1dFUjFfRElSfQoke0xPV0VSMl9ESVJ9CiR7TE9XRVIzX0RJUn0KRU9GCgpbIC1k
ICIke2xmfSIgXSB8fCBcCglleGl0IDEKClJPT1RfRElSPSIkKF9ta3RlbXBkaXIgIiR7V09SS19E
SVJ9IiAiUk9PVCIpIgpDT1dfRElSPSIkKF9ta3RlbXBkaXIgIiR7V09SS19ESVJ9IiAiQ09XIiki
CiNtb3VudCAtdCB0bXBmcyAtbyBydyB0bXBmcyAiJHtDT1dfRElSfSIKQ09XX0ZJTEU9IiQoX21r
dGVtcCAiJHtXT1JLX0RJUn0iICJDT1dGSUxFIikiCmRkIGlmPS9kZXYvemVybyBvZj0ke0NPV19G
SUxFfSBicz0xMDI0IGNvdW50PTAgc2Vlaz0kKCgxMDI0KjEyOCkpCiR7TUtGU19CSU59ICR7RlNf
T1BUU30gIiR7Q09XX0ZJTEV9Igptb3VudCAtbyBsb29wLHJ3ICIke0NPV19GSUxFfSIgIiR7Q09X
X0RJUn0iCgptb3VudCAtdCBvdmVybGF5ZnMgLW8gcncsbG93ZXJkaXI9IiR7bGZ9Iix1cHBlcmRp
cj0iJHtDT1dfRElSfSIgIm92ZXJsYXlmcyIgIiR7Uk9PVF9ESVJ9IgoKZWNobyAicm9vdGRpcjog
JHtST09UX0RJUn0iCmVjaG8gIkNPVzogJHtDT1dfRElSfSIKbW91bnQgLWwKCiMgQ09XCm1vdW50
IC1vIHJlbW91bnQscm8gIiR7Uk9PVF9ESVJ9IgpfdGVzdAoKI21vdW50IC1vIHJlbW91bnQscncg
IiR7Uk9PVF9ESVJ9IgojX3Rlc3QKCm1vdW50IC1vIHJlbW91bnQscncgIiR7Q09XX0RJUn0iCm1v
dW50IC1vIHJlbW91bnQscncgIiR7Uk9PVF9ESVJ9IiB8fCBlY2hvICIkez99IgpfdGVzdAoKbW91
bnQgLW8gcmVtb3VudCxydyAiJHtDT1dfRElSfSIKbW91bnQgLW8gcmVtb3VudCxydyxub2V4ZWMg
IiR7Uk9PVF9ESVJ9IgpfdGVzdAoKbW91bnQgLW8gcmVtb3VudCxydyxub2V4ZWMgIiR7Q09XX0RJ
Un0iCm1vdW50IC1vIHJlbW91bnQscncsbm9leGVjICIke1JPT1RfRElSfSIKX3Rlc3QKCiMgZXhp
dCAwCgp1bW91bnQgIiR7Uk9PVF9ESVJ9IgoKd2hpbGUgcmVhZCBmOyBkbwoJWyAtZCAiJHtmfSIg
XSAmJiBcCgltb3VudHBvaW50IC1xICIke2Z9IiAmJiBcCgl1bW91bnQgIiR7Zn0iIHx8IDoKZG9u
ZSA8PCBFT0YKJChmaW5kICIke1dPUktfRElSfSIgLW1pbmRlcHRoIDEgLW1heGRlcHRoIDEgLXR5
cGUgZCkKRU9GCgo6Cg==
--90e6ba1821c0f5775204c75d7598
Content-Type: application/octet-stream; 
	name="0001-fs-Increase-limit-filesystem-stacking-depth-to-3.patch"
Content-Disposition: attachment; 
	filename="0001-fs-Increase-limit-filesystem-stacking-depth-to-3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h5xjvn6f1

RnJvbSA0OGU4ZDQ3OGM3YWZiM2ZjZDlmNzViMzEwYWRkYTE1YjQ4MjU4YTU0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBTYXQsIDI4IEFwciAyMDEyIDE3OjExOjE2ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gZnM6
IEluY3JlYXNlIGxpbWl0IGZpbGVzeXN0ZW0gc3RhY2tpbmcgZGVwdGggdG8gMwoKClNpZ25lZC1v
ZmYtYnk6IFNlZGF0IERpbGVrIDxzZWRhdC5kaWxla0BnbWFpbC5jb20+Ci0tLQogaW5jbHVkZS9s
aW51eC9mcy5oIHwgICAgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9mcy5oIGIvaW5jbHVkZS9saW51
eC9mcy5oCmluZGV4IGZkZDFkMzguLmFkMzMzZTUgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgv
ZnMuaAorKysgYi9pbmNsdWRlL2xpbnV4L2ZzLmgKQEAgLTQ5Myw3ICs0OTMsNyBAQCBzdHJ1Y3Qg
aWF0dHIgewogICogTWF4aW11bSBudW1iZXIgb2YgbGF5ZXJzIG9mIGZzIHN0YWNrLiAgTmVlZHMg
dG8gYmUgbGltaXRlZCB0bwogICogcHJldmVudCBrZXJuZWwgc3RhY2sgb3ZlcmZsb3cKICAqLwot
I2RlZmluZSBGSUxFU1lTVEVNX01BWF9TVEFDS19ERVBUSCAyCisjZGVmaW5lIEZJTEVTWVNURU1f
TUFYX1NUQUNLX0RFUFRIIDMKIAogLyoqIAogICogZW51bSBwb3NpdGl2ZV9hb3BfcmV0dXJucyAt
IGFvcCByZXR1cm4gY29kZXMgd2l0aCBzcGVjaWZpYyBzZW1hbnRpY3MKLS0gCjEuNy45LjUKCg==
--90e6ba1821c0f5775204c75d7598--
