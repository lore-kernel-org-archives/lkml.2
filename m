Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab2IUTQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:16:21 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:58609 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757460Ab2IUTQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:16:19 -0400
Message-ID: <505CBCD9.7060908@xenotime.net>
Date: Fri, 21 Sep 2012 12:15:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: halfdog <me@halfdog.net>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix kernel stack data disclosure in binfmt_script during
 execve
References: <502FA000.8090700@halfdog.net> <5030A65D.90305@halfdog.net> <503553EF.1090508@halfdog.net> <20120823085625.GA4683@otc-wbsnb-06> <50375302.1050603@halfdog.net> <505B3EDB.8020009@halfdog.net>
In-Reply-To: <505B3EDB.8020009@halfdog.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 09:05 AM, halfdog wrote:

> halfdog wrote:
> 
> Now this is the updated and also tested patch (vs. linux-3.5.4 kernel) to fix
> https://bugzilla.kernel.org/show_bug.cgi?id=46841 . See also
> http://www.halfdog.net/Security/2012/LinuxKernelBinfmtScriptStackDataDisclosure/
> This patch adresses the stack data disclosure but does not deal with the
> excessive recursion (to be handled in separate patch if needed).
> 
> --- fs/binfmt_script.c	2012-09-14 22:28:08.000000000 +0000
> +++ fs/binfmt_script.c	2012-09-20 16:01:58.951942355 +0000


Incorrect diff/patch format for kernel patches.
It should be apply-able by using 'patch -p1'.

Oh, the patch is not signed off.
And Documentation/SubmittingPatches says signoffs are:

"using your real name (sorry, no pseudonyms or anonymous contributions.)"

There are also some kernel coding style issues that should be
fixed if this patch is to be merged.

> @@ -14,12 +14,24 @@
>  #include <linux/err.h>
>  #include <linux/fs.h>
> 
> +/** Check if this handler is suitable to load the "binary" identified


/** means kernel-doc notation in the kernel, but this comment
block is not kernel-doc, so don't start it with /**

> + *  by first BINPRM_BUF_SIZE bytes in bprm->buf.
> + *  @returns -ENOEXEC if this handler is not suitable for that type


We don't use "@returns", just returns: <text>.

> + *  of binary. In that case, the handler must not modify any of the
> + *  data associated with bprm.
> + *  Any error if the binary should have been handled by this loader
> + *  but handling failed. In that case. FIXME: be defensive? also
> + *  kill bprm->mm or bprm->file also to make it impossible, that
> + *  upper search_binary_handler can continue handling?
> + *  0 (OK) otherwise, the new executable is ready in bprm->mm.
> + */
>  static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
>  {
>  	const char *i_arg, *i_name;
>  	char *cp;
>  	struct file *file;
> -	char interp[BINPRM_BUF_SIZE];
> +	char bprm_buf_copy[BINPRM_BUF_SIZE];
> +	const char *bprm_old_interp_name;
>  	int retval;
> 
>  	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!') ||
> @@ -30,25 +42,29 @@ static int load_script(struct linux_binp
>  	 * Sorta complicated, but hopefully it will work.  -TYT
>  	 */
> 
> -	bprm->recursion_depth++;
> -	allow_write_access(bprm->file);
> -	fput(bprm->file);
> -	bprm->file = NULL;
> +	/* Keep bprm unchanged until we known, that this is a script
> +	 * to be handled by this loader. Copy bprm->buf for sure,
> +	 * otherwise returning -ENOEXEC will make other handlers see
> +	 * modified data. (hd)
> +	 */


Kernel multi-line comment style is
	/*
	 * line 1
	 * line 2
	 */

> +	memcpy(bprm_buf_copy, bprm->buf, BINPRM_BUF_SIZE);
> 
> -	bprm->buf[BINPRM_BUF_SIZE - 1] = '\0';
> -	if ((cp = strchr(bprm->buf, '\n')) == NULL)
> -		cp = bprm->buf+BINPRM_BUF_SIZE-1;
> +	bprm_buf_copy[BINPRM_BUF_SIZE - 1]='\0';
> +	if ((cp = strchr(bprm_buf_copy, '\n')) == NULL)
> +		cp = bprm_buf_copy+BINPRM_BUF_SIZE-1;
>  	*cp = '\0';
> -	while (cp > bprm->buf) {
> +	while (cp > bprm_buf_copy) {
>  		cp--;
>  		if ((*cp == ' ') || (*cp == '\t'))
>  			*cp = '\0';
>  		else
>  			break;
>  	}
> -	for (cp = bprm->buf+2; (*cp == ' ') || (*cp == '\t'); cp++);
> +	for (cp = bprm_buf_copy+2; (*cp == ' ') || (*cp == '\t'); cp++);
>  	if (*cp == '\0')
> -		return -ENOEXEC; /* No interpreter name found */
> +	/* No interpreter name found. No problem to let other handlers
> +	 * retry, we did not change anything. */


multi-line comment style.

> +		return -ENOEXEC;
>  	i_name = cp;
>  	i_arg = NULL;
>  	for ( ; *cp && (*cp != ' ') && (*cp != '\t'); cp++)
> @@ -57,45 +73,84 @@ static int load_script(struct linux_binp
>  		*cp++ = '\0';
>  	if (*cp)
>  		i_arg = cp;
> -	strcpy (interp, i_name);
> +
> +	/* So this is our point-of-no-return: modification of bprm
> +	 * will be irreversible, so if we fail to setup execution
> +	 * using the new interpreter name (i_name), we have to make
> +	 * sure, that no other handler tries again. (hd)
> +	 */


ditto.

> +
>  	/*
>  	 * OK, we've parsed out the interpreter name and
>  	 * (optional) argument.
>  	 * Splice in (1) the interpreter's name for argv[0]
> -	 *           (2) (optional) argument to interpreter
> -	 *           (3) filename of shell script (replace argv[0])
> +	 *	   (2) (optional) argument to interpreter
> +	 *	   (3) filename of shell script (replace argv[0])
>  	 *
>  	 * This is done in reverse order, because of how the
>  	 * user environment and arguments are stored.
>  	 */
> +
> +	/* Ugly: we store pointer to local stack frame in bprm,
> +	 * so make sure to clear this up before returning.
> +	 */


ditto.

> +	bprm_old_interp_name = bprm->interp;
> +	bprm->interp = i_name;
> +
>  	retval = remove_arg_zero(bprm);
> -	if (retval)
> -		return retval;
> -	retval = copy_strings_kernel(1, &bprm->interp, bprm);
> -	if (retval < 0) return retval;
> +	if (retval) goto out;


Really should be
	if (retval)
		goto out;

> +	/* copy_strings_kernel is ok here, even when racy: since no
> +	 * user can be attached to new mm, there is nobody to race
> +	 * with and call is safe for now. The return code of
> +	 * copy_strings_kernel cannot be -ENOEXEC in any case,
> +	 * so no special checks needed. (hd)
> +	 */


style.

> +	retval = copy_strings_kernel(1, &bprm_old_interp_name, bprm);
> +	if (retval < 0) goto out;
>  	bprm->argc++;
>  	if (i_arg) {
>  		retval = copy_strings_kernel(1, &i_arg, bprm);
> -		if (retval < 0) return retval;
> +		if (retval < 0) goto out;


style.

>  		bprm->argc++;
>  	}
> -	retval = copy_strings_kernel(1, &i_name, bprm);
> -	if (retval) return retval;
> +	retval = copy_strings_kernel(1, &bprm->interp, bprm);
> +	if (retval) goto out;


style.  (but Al can override these if he wants to)

>  	bprm->argc++;
> -	bprm->interp = interp;
> 
>  	/*
>  	 * OK, now restart the process with the interpreter's dentry.
> +         * Release old file first


indentation mucked up.

>  	 */
> -	file = open_exec(interp);
> -	if (IS_ERR(file))
> -		return PTR_ERR(file);
> -
> +	allow_write_access(bprm->file);
> +	fput(bprm->file);
> +	bprm->file = NULL;
> +	file = open_exec(bprm->interp);
> +	if (IS_ERR(file)) {
> +		retval=PTR_ERR(file);
> +		goto out;
> +        }
>  	bprm->file = file;
> +	/* Caveat: This also updates the credentials of the next exec. */
>  	retval = prepare_binprm(bprm);
>  	if (retval < 0)
> -		return retval;
> -	return search_binary_handler(bprm,regs);
> +		goto out;
> +	bprm->recursion_depth++;
> +	retval=search_binary_handler(bprm,regs);
> +
> +out:	/* Make sure, we do not return local stack frame data. If
> +	 * it would be needed after returning, we would have needed
> +	 * to allocate memory or use copy from new bprm->mm anyway. (hd)
> +         */


Comment block probably should come before the label.
and the indentation is mucked up.

> +	bprm->interp = bprm_old_interp_name;
> +	if(!retval) {
> +		/* The handlers for starting of interpreter failed.
> +		 * bprm is already modified, hence we are dead here.
> +		 * Make sure, that we do not return -ENOEXEC, that would
> +		 * allow searching for handlers to continue. (hd).
> +		 */

style

> +		if(retval==-ENOEXEC) retval=-EINVAL;


missing space before '('.
etc.

> +	}
> +	return(retval);
>  }
> 
>  static struct linux_binfmt script_format = {
> 



-- 
~Randy
