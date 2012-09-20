Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab2ITQJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 12:09:50 -0400
Received: from ext190.halfdog.net ([88.116.147.190]:36391 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab2ITQJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 12:09:48 -0400
Message-ID: <505B3EDB.8020009@halfdog.net>
Date: Thu, 20 Sep 2012 16:05:47 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:18.0) Gecko/18.0 Firefox/18.0 SeaMonkey/2.15a1
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix kernel stack data disclosure in binfmt_script during
 execve
References: <502FA000.8090700@halfdog.net> <5030A65D.90305@halfdog.net> <503553EF.1090508@halfdog.net> <20120823085625.GA4683@otc-wbsnb-06> <50375302.1050603@halfdog.net>
In-Reply-To: <50375302.1050603@halfdog.net>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

halfdog wrote:
> Kirill A. Shutemov wrote:
>> On Wed, Aug 22, 2012 at 09:49:35PM +0000, halfdog wrote:
>>> Got a hint via IRC, that I should not send patch idea for review 
>>> to "generic" list, but to maintainers and last (or relevant) 
>>> comitters of code.
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=bf2a9a39639b8b51377905397a5005f444e9a892
>>>
>>>
> ...
>>> halfdog wrote:
>>>> halfdog wrote:
>>>>> I'm searching for a patch for linux kernel stack disclosure 
>>>>> in binfmt_script with crafted interpreter names when 
>>>>> CONFIG_MODULES is active (see [1]).
>>>>
>>>> Please disregard my previous proposal [2], since it did not 
>>>> address the problem directly (referencing local stack frame 
>>>> data from bprm structure) but worked around it. I suspect,
>>>> that this could increase probability to reintroduce similar
>>>> bugs.
>>>>
>>>> Opinions on (untested sketch for) second solution: Could 
>>>> someone look on the source code comments and changes in patch 
>>>> to judge, if this is going in the right direction?
>>>>
>>>> Explanation of patch: Since load_script will start to 
>>>> irreversibly change bprm structures at some point (using stack 
>>>> local data was one of those changes), try to delay this point. 
>>>> Run checks if load_script could be the right handler, if not 
>>>> give other binfmt handlers the chance to do so.
>>>>
>>>> If binfmt_script is the right one, try to load the interpreter
>>>>  (causing bprm modification), if failing make sure that no
>>>> other binfmt handler has the chance to continue on the now
>>>> modified bprm data.
>>>>
>>>> CAVEAT: This assumes, that if binfmt_script could handle the 
>>>> load, that it would be the one and only binfmt with that 
>>>> ability, so no other one, e.g. binfmt_misc should have the 
>>>> chance to do so. If this assumption is wrong, leaving 
>>>> binfmt_script would have to rollback all bprm changes (e.g. 
>>>> restore old credentials).
>>>>
>>>> [1]
>>>> http://www.halfdog.net/Security/2012/LinuxKernelBinfmtScriptStackDataDisclosure/
>>>>
>>>>
> [2] http://lkml.org/lkml/2012/8/18/75
> 
>> What about (untested):
> 
>> diff --git a/fs/exec.c b/fs/exec.c index 574cf4d..ef13850 100644 
>> --- a/fs/exec.c +++ b/fs/exec.c @@ -1438,7 +1438,8 @@ int 
>> search_binary_handler(struct linux_binprm *bprm,struct pt_regs 
>> *regs) } read_unlock(&binfmt_lock); #ifdef CONFIG_MODULES -		if 
>> (retval != -ENOEXEC || bprm->mm == NULL) { +		if (retval != 
>> -ENOEXEC || bprm->mm == NULL || +				bprm->recursion_depth > 
>> BINPRM_MAX_RECURSION) { break; } else { #define printable(c) 
>> (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
> 
> - From my understanding, this patch should not fix the problem, since
> recursion depth is reset back to old value after call of binfmt handler.
> This is done, so that fs/exec does not have to trust all binfmts to
> reset the depth by themselfes when leaving.
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=blob;f=fs/exec.c;h=da27b91ff1e8cbe87d0fe42aa5d39513e6a9deeb;hb=HEAD
>    1408                         read_unlock(&binfmt_lock);
>    1409                         retval = fn(bprm, regs);
>    1410                         /*
>    1411                          * Restore the depth counter to its
> starting value
>    1412                          * in this call, so we don't have to
> rely on every
>    1413                          * load_binary function to restore it on
> return.
>    1414                          */
>    1415                         bprm->recursion_depth = depth;
> 
> 
> I guess, the problem is, that recursion_depth usually not only limits
> the depth, but also the maximal number of binfmt_xxx calls. That's why,
> the use of local stack-frame data in bprm does not matter, there is no
> going up the stack AND using bprm->interpreter, the last error is
> terminates the search.
> 
> In the POC, search is not terminated because of ENOEXEC when max depth
> reached and due to special filename, mod-loader triggers also (about 30
> times? I do not known, if that could be a problem also, interfering with
> other module loads. Usually non-root users cannot trigger rapid module
> loads easily).

>> What about (untested):

Now this is the updated and also tested patch (vs. linux-3.5.4 kernel) to fix
https://bugzilla.kernel.org/show_bug.cgi?id=46841 . See also
http://www.halfdog.net/Security/2012/LinuxKernelBinfmtScriptStackDataDisclosure/
This patch adresses the stack data disclosure but does not deal with the
excessive recursion (to be handled in separate patch if needed).

--- fs/binfmt_script.c	2012-09-14 22:28:08.000000000 +0000
+++ fs/binfmt_script.c	2012-09-20 16:01:58.951942355 +0000
@@ -14,12 +14,24 @@
 #include <linux/err.h>
 #include <linux/fs.h>

+/** Check if this handler is suitable to load the "binary" identified
+ *  by first BINPRM_BUF_SIZE bytes in bprm->buf.
+ *  @returns -ENOEXEC if this handler is not suitable for that type
+ *  of binary. In that case, the handler must not modify any of the
+ *  data associated with bprm.
+ *  Any error if the binary should have been handled by this loader
+ *  but handling failed. In that case. FIXME: be defensive? also
+ *  kill bprm->mm or bprm->file also to make it impossible, that
+ *  upper search_binary_handler can continue handling?
+ *  0 (OK) otherwise, the new executable is ready in bprm->mm.
+ */
 static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 {
 	const char *i_arg, *i_name;
 	char *cp;
 	struct file *file;
-	char interp[BINPRM_BUF_SIZE];
+	char bprm_buf_copy[BINPRM_BUF_SIZE];
+	const char *bprm_old_interp_name;
 	int retval;

 	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!') ||
@@ -30,25 +42,29 @@ static int load_script(struct linux_binp
 	 * Sorta complicated, but hopefully it will work.  -TYT
 	 */

-	bprm->recursion_depth++;
-	allow_write_access(bprm->file);
-	fput(bprm->file);
-	bprm->file = NULL;
+	/* Keep bprm unchanged until we known, that this is a script
+	 * to be handled by this loader. Copy bprm->buf for sure,
+	 * otherwise returning -ENOEXEC will make other handlers see
+	 * modified data. (hd)
+	 */
+	memcpy(bprm_buf_copy, bprm->buf, BINPRM_BUF_SIZE);

-	bprm->buf[BINPRM_BUF_SIZE - 1] = '\0';
-	if ((cp = strchr(bprm->buf, '\n')) == NULL)
-		cp = bprm->buf+BINPRM_BUF_SIZE-1;
+	bprm_buf_copy[BINPRM_BUF_SIZE - 1]='\0';
+	if ((cp = strchr(bprm_buf_copy, '\n')) == NULL)
+		cp = bprm_buf_copy+BINPRM_BUF_SIZE-1;
 	*cp = '\0';
-	while (cp > bprm->buf) {
+	while (cp > bprm_buf_copy) {
 		cp--;
 		if ((*cp == ' ') || (*cp == '\t'))
 			*cp = '\0';
 		else
 			break;
 	}
-	for (cp = bprm->buf+2; (*cp == ' ') || (*cp == '\t'); cp++);
+	for (cp = bprm_buf_copy+2; (*cp == ' ') || (*cp == '\t'); cp++);
 	if (*cp == '\0')
-		return -ENOEXEC; /* No interpreter name found */
+	/* No interpreter name found. No problem to let other handlers
+	 * retry, we did not change anything. */
+		return -ENOEXEC;
 	i_name = cp;
 	i_arg = NULL;
 	for ( ; *cp && (*cp != ' ') && (*cp != '\t'); cp++)
@@ -57,45 +73,84 @@ static int load_script(struct linux_binp
 		*cp++ = '\0';
 	if (*cp)
 		i_arg = cp;
-	strcpy (interp, i_name);
+
+	/* So this is our point-of-no-return: modification of bprm
+	 * will be irreversible, so if we fail to setup execution
+	 * using the new interpreter name (i_name), we have to make
+	 * sure, that no other handler tries again. (hd)
+	 */
+
 	/*
 	 * OK, we've parsed out the interpreter name and
 	 * (optional) argument.
 	 * Splice in (1) the interpreter's name for argv[0]
-	 *           (2) (optional) argument to interpreter
-	 *           (3) filename of shell script (replace argv[0])
+	 *	   (2) (optional) argument to interpreter
+	 *	   (3) filename of shell script (replace argv[0])
 	 *
 	 * This is done in reverse order, because of how the
 	 * user environment and arguments are stored.
 	 */
+
+	/* Ugly: we store pointer to local stack frame in bprm,
+	 * so make sure to clear this up before returning.
+	 */
+	bprm_old_interp_name = bprm->interp;
+	bprm->interp = i_name;
+
 	retval = remove_arg_zero(bprm);
-	if (retval)
-		return retval;
-	retval = copy_strings_kernel(1, &bprm->interp, bprm);
-	if (retval < 0) return retval;
+	if (retval) goto out;
+	/* copy_strings_kernel is ok here, even when racy: since no
+	 * user can be attached to new mm, there is nobody to race
+	 * with and call is safe for now. The return code of
+	 * copy_strings_kernel cannot be -ENOEXEC in any case,
+	 * so no special checks needed. (hd)
+	 */
+	retval = copy_strings_kernel(1, &bprm_old_interp_name, bprm);
+	if (retval < 0) goto out;
 	bprm->argc++;
 	if (i_arg) {
 		retval = copy_strings_kernel(1, &i_arg, bprm);
-		if (retval < 0) return retval;
+		if (retval < 0) goto out;
 		bprm->argc++;
 	}
-	retval = copy_strings_kernel(1, &i_name, bprm);
-	if (retval) return retval;
+	retval = copy_strings_kernel(1, &bprm->interp, bprm);
+	if (retval) goto out;
 	bprm->argc++;
-	bprm->interp = interp;

 	/*
 	 * OK, now restart the process with the interpreter's dentry.
+         * Release old file first
 	 */
-	file = open_exec(interp);
-	if (IS_ERR(file))
-		return PTR_ERR(file);
-
+	allow_write_access(bprm->file);
+	fput(bprm->file);
+	bprm->file = NULL;
+	file = open_exec(bprm->interp);
+	if (IS_ERR(file)) {
+		retval=PTR_ERR(file);
+		goto out;
+        }
 	bprm->file = file;
+	/* Caveat: This also updates the credentials of the next exec. */
 	retval = prepare_binprm(bprm);
 	if (retval < 0)
-		return retval;
-	return search_binary_handler(bprm,regs);
+		goto out;
+	bprm->recursion_depth++;
+	retval=search_binary_handler(bprm,regs);
+
+out:	/* Make sure, we do not return local stack frame data. If
+	 * it would be needed after returning, we would have needed
+	 * to allocate memory or use copy from new bprm->mm anyway. (hd)
+         */
+	bprm->interp = bprm_old_interp_name;
+	if(!retval) {
+		/* The handlers for starting of interpreter failed.
+		 * bprm is already modified, hence we are dead here.
+		 * Make sure, that we do not return -ENOEXEC, that would
+		 * allow searching for handlers to continue. (hd).
+		 */
+		if(retval==-ENOEXEC) retval=-EINVAL;
+	}
+	return(retval);
 }

 static struct linux_binfmt script_format = {

-- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
