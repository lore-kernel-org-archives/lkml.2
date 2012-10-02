Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2JBFsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 01:48:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57701 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2JBFsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 01:48:30 -0400
Date: Tue, 2 Oct 2012 15:48:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Kelly <alex.page.kelly@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the signal tree with the vfs tree
Message-Id: <20121002154820.a565ec5728901c440bd57349@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Oct_2012_15_48_20_+1000_YEpYJV6H5t+nA1GJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Oct_2012_15_48_20_+1000_YEpYJV6H5t+nA1GJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in fs/exec.c
between commit 5b8a94d461a7 ("coredump: move core dump functionality into
its own file") from the vfs tree and commits 282124d18626 ("generic
kernel_execve()") and 38b983b3461e ("generic sys_execve()") from the signal=
 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/exec.c
index 48fb26e,50a1270..0000000
--- a/fs/exec.c
+++ b/fs/exec.c
@@@ -1645,3 -2031,342 +1644,55 @@@ int get_dumpable(struct mm_struct *mm
  {
  	return __get_dumpable(mm->flags);
  }
+=20
 -static void wait_for_dump_helpers(struct file *file)
 -{
 -	struct pipe_inode_info *pipe;
 -
 -	pipe =3D file->f_path.dentry->d_inode->i_pipe;
 -
 -	pipe_lock(pipe);
 -	pipe->readers++;
 -	pipe->writers--;
 -
 -	while ((pipe->readers > 1) && (!signal_pending(current))) {
 -		wake_up_interruptible_sync(&pipe->wait);
 -		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 -		pipe_wait(pipe);
 -	}
 -
 -	pipe->readers--;
 -	pipe->writers++;
 -	pipe_unlock(pipe);
 -
 -}
 -
 -
 -/*
 - * umh_pipe_setup
 - * helper function to customize the process used
 - * to collect the core in userspace.  Specifically
 - * it sets up a pipe and installs it as fd 0 (stdin)
 - * for the process.  Returns 0 on success, or
 - * PTR_ERR on failure.
 - * Note that it also sets the core limit to 1.  This
 - * is a special value that we use to trap recursive
 - * core dumps
 - */
 -static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 -{
 -	struct file *files[2];
 -	struct fdtable *fdt;
 -	struct coredump_params *cp =3D (struct coredump_params *)info->data;
 -	struct files_struct *cf =3D current->files;
 -	int err =3D create_pipe_files(files, 0);
 -	if (err)
 -		return err;
 -
 -	cp->file =3D files[1];
 -
 -	sys_close(0);
 -	fd_install(0, files[0]);
 -	spin_lock(&cf->file_lock);
 -	fdt =3D files_fdtable(cf);
 -	__set_open_fd(0, fdt);
 -	__clear_close_on_exec(0, fdt);
 -	spin_unlock(&cf->file_lock);
 -
 -	/* and disallow core files too */
 -	current->signal->rlim[RLIMIT_CORE] =3D (struct rlimit){1, 1};
 -
 -	return 0;
 -}
 -
 -void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 -{
 -	struct core_state core_state;
 -	struct core_name cn;
 -	struct mm_struct *mm =3D current->mm;
 -	struct linux_binfmt * binfmt;
 -	const struct cred *old_cred;
 -	struct cred *cred;
 -	int retval =3D 0;
 -	int flag =3D 0;
 -	int ispipe;
 -	bool need_nonrelative =3D false;
 -	static atomic_t core_dump_count =3D ATOMIC_INIT(0);
 -	struct coredump_params cprm =3D {
 -		.signr =3D signr,
 -		.regs =3D regs,
 -		.limit =3D rlimit(RLIMIT_CORE),
 -		/*
 -		 * We must use the same mm->flags while dumping core to avoid
 -		 * inconsistency of bit flags, since this flag is not protected
 -		 * by any locks.
 -		 */
 -		.mm_flags =3D mm->flags,
 -	};
 -
 -	audit_core_dumps(signr);
 -
 -	binfmt =3D mm->binfmt;
 -	if (!binfmt || !binfmt->core_dump)
 -		goto fail;
 -	if (!__get_dumpable(cprm.mm_flags))
 -		goto fail;
 -
 -	cred =3D prepare_creds();
 -	if (!cred)
 -		goto fail;
 -	/*
 -	 * We cannot trust fsuid as being the "true" uid of the process
 -	 * nor do we know its entire history. We only know it was tainted
 -	 * so we dump it as root in mode 2, and only into a controlled
 -	 * environment (pipe handler or fully qualified path).
 -	 */
 -	if (__get_dumpable(cprm.mm_flags) =3D=3D SUID_DUMPABLE_SAFE) {
 -		/* Setuid core dump mode */
 -		flag =3D O_EXCL;		/* Stop rewrite attacks */
 -		cred->fsuid =3D GLOBAL_ROOT_UID;	/* Dump root private */
 -		need_nonrelative =3D true;
 -	}
 -
 -	retval =3D coredump_wait(exit_code, &core_state);
 -	if (retval < 0)
 -		goto fail_creds;
 -
 -	old_cred =3D override_creds(cred);
 -
 -	/*
 -	 * Clear any false indication of pending signals that might
 -	 * be seen by the filesystem code called to write the core file.
 -	 */
 -	clear_thread_flag(TIF_SIGPENDING);
 -
 -	ispipe =3D format_corename(&cn, signr);
 -
 - 	if (ispipe) {
 -		int dump_count;
 -		char **helper_argv;
 -
 -		if (ispipe < 0) {
 -			printk(KERN_WARNING "format_corename failed\n");
 -			printk(KERN_WARNING "Aborting core\n");
 -			goto fail_corename;
 -		}
 -
 -		if (cprm.limit =3D=3D 1) {
 -			/* See umh_pipe_setup() which sets RLIMIT_CORE =3D 1.
 -			 *
 -			 * Normally core limits are irrelevant to pipes, since
 -			 * we're not writing to the file system, but we use
 -			 * cprm.limit of 1 here as a speacial value, this is a
 -			 * consistent way to catch recursive crashes.
 -			 * We can still crash if the core_pattern binary sets
 -			 * RLIM_CORE =3D !1, but it runs as root, and can do
 -			 * lots of stupid things.
 -			 *
 -			 * Note that we use task_tgid_vnr here to grab the pid
 -			 * of the process group leader.  That way we get the
 -			 * right pid if a thread in a multi-threaded
 -			 * core_pattern process dies.
 -			 */
 -			printk(KERN_WARNING
 -				"Process %d(%s) has RLIMIT_CORE set to 1\n",
 -				task_tgid_vnr(current), current->comm);
 -			printk(KERN_WARNING "Aborting core\n");
 -			goto fail_unlock;
 -		}
 -		cprm.limit =3D RLIM_INFINITY;
 -
 -		dump_count =3D atomic_inc_return(&core_dump_count);
 -		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
 -			printk(KERN_WARNING "Pid %d(%s) over core_pipe_limit\n",
 -			       task_tgid_vnr(current), current->comm);
 -			printk(KERN_WARNING "Skipping core dump\n");
 -			goto fail_dropcount;
 -		}
 -
 -		helper_argv =3D argv_split(GFP_KERNEL, cn.corename+1, NULL);
 -		if (!helper_argv) {
 -			printk(KERN_WARNING "%s failed to allocate memory\n",
 -			       __func__);
 -			goto fail_dropcount;
 -		}
 -
 -		retval =3D call_usermodehelper_fns(helper_argv[0], helper_argv,
 -					NULL, UMH_WAIT_EXEC, umh_pipe_setup,
 -					NULL, &cprm);
 -		argv_free(helper_argv);
 -		if (retval) {
 - 			printk(KERN_INFO "Core dump to %s pipe failed\n",
 -			       cn.corename);
 -			goto close_fail;
 - 		}
 -	} else {
 -		struct inode *inode;
 -
 -		if (cprm.limit < binfmt->min_coredump)
 -			goto fail_unlock;
 -
 -		if (need_nonrelative && cn.corename[0] !=3D '/') {
 -			printk(KERN_WARNING "Pid %d(%s) can only dump core "\
 -				"to fully qualified path!\n",
 -				task_tgid_vnr(current), current->comm);
 -			printk(KERN_WARNING "Skipping core dump\n");
 -			goto fail_unlock;
 -		}
 -
 -		cprm.file =3D filp_open(cn.corename,
 -				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 -				 0600);
 -		if (IS_ERR(cprm.file))
 -			goto fail_unlock;
 -
 -		inode =3D cprm.file->f_path.dentry->d_inode;
 -		if (inode->i_nlink > 1)
 -			goto close_fail;
 -		if (d_unhashed(cprm.file->f_path.dentry))
 -			goto close_fail;
 -		/*
 -		 * AK: actually i see no reason to not allow this for named
 -		 * pipes etc, but keep the previous behaviour for now.
 -		 */
 -		if (!S_ISREG(inode->i_mode))
 -			goto close_fail;
 -		/*
 -		 * Dont allow local users get cute and trick others to coredump
 -		 * into their pre-created files.
 -		 */
 -		if (!uid_eq(inode->i_uid, current_fsuid()))
 -			goto close_fail;
 -		if (!cprm.file->f_op || !cprm.file->f_op->write)
 -			goto close_fail;
 -		if (do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file))
 -			goto close_fail;
 -	}
 -
 -	retval =3D binfmt->core_dump(&cprm);
 -	if (retval)
 -		current->signal->group_exit_code |=3D 0x80;
 -
 -	if (ispipe && core_pipe_limit)
 -		wait_for_dump_helpers(cprm.file);
 -close_fail:
 -	if (cprm.file)
 -		filp_close(cprm.file, NULL);
 -fail_dropcount:
 -	if (ispipe)
 -		atomic_dec(&core_dump_count);
 -fail_unlock:
 -	kfree(cn.corename);
 -fail_corename:
 -	coredump_finish(mm);
 -	revert_creds(old_cred);
 -fail_creds:
 -	put_cred(cred);
 -fail:
 -	return;
 -}
 -
 -/*
 - * Core dumping helper functions.  These are the only things you should
 - * do on a core-file: use only these functions to write out all the
 - * necessary info.
 - */
 -int dump_write(struct file *file, const void *addr, int nr)
 -{
 -	return access_ok(VERIFY_READ, addr, nr) && file->f_op->write(file, addr,=
 nr, &file->f_pos) =3D=3D nr;
 -}
 -EXPORT_SYMBOL(dump_write);
 -
 -int dump_seek(struct file *file, loff_t off)
 -{
 -	int ret =3D 1;
 -
 -	if (file->f_op->llseek && file->f_op->llseek !=3D no_llseek) {
 -		if (file->f_op->llseek(file, off, SEEK_CUR) < 0)
 -			return 0;
 -	} else {
 -		char *buf =3D (char *)get_zeroed_page(GFP_KERNEL);
 -
 -		if (!buf)
 -			return 0;
 -		while (off > 0) {
 -			unsigned long n =3D off;
 -
 -			if (n > PAGE_SIZE)
 -				n =3D PAGE_SIZE;
 -			if (!dump_write(file, buf, n)) {
 -				ret =3D 0;
 -				break;
 -			}
 -			off -=3D n;
 -		}
 -		free_page((unsigned long)buf);
 -	}
 -	return ret;
 -}
 -EXPORT_SYMBOL(dump_seek);
 -
+ #ifdef __ARCH_WANT_SYS_EXECVE
+ SYSCALL_DEFINE3(execve,
+ 		const char __user *, filename,
+ 		const char __user *const __user *, argv,
+ 		const char __user *const __user *, envp)
+ {
+ 	const char *path =3D getname(filename);
+ 	int error =3D PTR_ERR(path);
+ 	if (!IS_ERR(path)) {
+ 		error =3D do_execve(path, argv, envp, current_pt_regs());
+ 		putname(path);
+ 	}
+ 	return error;
+ }
+ #ifdef CONFIG_COMPAT
+ asmlinkage long compat_sys_execve(const char __user * filename,
+ 	const compat_uptr_t __user * argv,
+ 	const compat_uptr_t __user * envp)
+ {
+ 	const char *path =3D getname(filename);
+ 	int error =3D PTR_ERR(path);
+ 	if (!IS_ERR(path)) {
+ 		error =3D compat_do_execve(path, argv, envp, current_pt_regs());
+ 		putname(path);
+ 	}
+ 	return error;
+ }
+ #endif
+ #endif
+=20
+ #ifdef __ARCH_WANT_KERNEL_EXECVE
+ int kernel_execve(const char *filename,
+ 		  const char *const argv[],
+ 		  const char *const envp[])
+ {
+ 	struct pt_regs *p =3D current_pt_regs();
+ 	int ret;
+=20
+ 	ret =3D do_execve(filename,
+ 			(const char __user *const __user *)argv,
+ 			(const char __user *const __user *)envp, p);
+ 	if (ret < 0)
+ 		return ret;
+=20
+ 	/*
+ 	 * We were successful.  We won't be returning to our caller, but
+ 	 * instead to user space by manipulating the kernel stack.
+ 	 */
+ 	ret_from_kernel_execve(p);
+ }
+ #endif

--Signature=_Tue__2_Oct_2012_15_48_20_+1000_YEpYJV6H5t+nA1GJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQaoAkAAoJEECxmPOUX5FEG9IP/iQk4c0f2Eprg2vQk/T2Kfam
rop1FW0hWxWNiKsoz7++F/tcD8YQZf4mppFrRX2S/Uu/iGBGvB5e5APSmkatiina
Bj+ZnQtvWc4R1FQSeHoiPOZpL00w8TOJkWOpdCl8MAHnIH4xT1Cx7CIXsOBDR80L
7hZHvnoQQlu25TOIwxsehXSVjubJrhgKT+W2U4PIkFDA8C4NOWfalc4TLHxBca85
dt/T5Il1Fxflwd/Bn7sqqVzFfvRXzvRfEDbUSLDfHw8PeVA/fPb9mMVXIaCqyA16
unh0Ch2PjMNSVUJFkgO4DErXWY4+KWQUyqUaGZmIj+IH9knXPGA4v0lHmXcuHD/l
/SWe4IO7TTHS/LV5LFoCc7Gm6xxgzmfJAmtSY0MWEMqu1nhNUHfFA5fa++W68aSb
ICaLH7Xbsji1mt858V8XqiMAkg8rDmdPsIsMtXQy36MlhZ7DJl4l4i6XVd6B7wxI
aH9ThtvJPwdZM3f2Z37jKKwuzP6N4k7AL40QVSXcAniadD9gE3YyM3QiJ3UFVMgi
j4It88cjhnBI62Tb2Ms/FJw8qs6q770oes7mQrgBG09M2BR3Xnh56kmr3SrZbEjq
Cs4S1TzK+akwmH+MqrGa/+uUJ13mtbYSJSSGkJA97JWZENN7pz+ynZy2g8mJykeJ
NCa11ZZ/eScq6DzqK14J
=VK3p
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Oct_2012_15_48_20_+1000_YEpYJV6H5t+nA1GJ--
