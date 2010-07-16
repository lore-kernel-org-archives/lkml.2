Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab0GPFVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 01:21:53 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59588 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab0GPFVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 01:21:50 -0400
Message-Id: <201007160521.o6G5Li2j093689@www262.sakura.ne.jp>
Subject: Re: [AppArmor #5 0/13] AppArmor security module
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: john.johansen@canonical.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Jul 2010 14:21:44 +0900
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com> <E1OZO8Z-0004a5-6S@pomaz-ex.szeredi.hu>
In-Reply-To: <E1OZO8Z-0004a5-6S@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 16072010 #3972488, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LXR as of 7889ab2 "AppArmor: Drop CONFIG_SECURITY_APPARMOR_COMPAT_24"
is at http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/?v=apparmor-dev .




Regarding apparmorfs.c

 58 static void kvfree(void *buffer)
 59 {
 60         if (!buffer)
 61                 return;
 62 
 63         if (is_vmalloc_addr(buffer))
 64                 vfree(buffer);
 65         else
 66                 kfree(buffer);
 67 }

You can omit

	if (!buffer)
		return;

(if you want) because is_vmalloc_addr(NULL) is false and kfree(NULL) is no-op.



 80 static char *aa_simple_write_to_buffer(int op, const char __user *userbuf,
 81                                        size_t alloc_size, size_t copy_size,
 82                                        loff_t *pos)
 83 {
 84         char *data;
 85 
 86         if (*pos != 0) {
 87                 /* only writes from pos 0, that is complete writes */

You can

	return ERR_PTR(-ESPIPE);

here.

 88                 data = ERR_PTR(-ESPIPE);
 89                 goto out;
 90         }
 91 
 92         /*
 93          * Don't allow profile load/replace/remove from profiles that don't
 94          * have CAP_MAC_ADMIN
 95          */
 96         if (!aa_may_manage_policy(op))
 97                 return ERR_PTR(-EACCES);
 98 
 99         /* freed by caller to simple_write_to_buffer */
100         data = kvmalloc(alloc_size);
101         if (data == NULL)
102                 return ERR_PTR(-ENOMEM);
103 
104         if (copy_from_user(data, userbuf, copy_size)) {
105                 kvfree(data);

You can

	return ERR_PTR(-EFAULT);

here.

106                 data = ERR_PTR(-EFAULT);
107                 goto out;
108         }
109 
110 out:

This label will become unused.

111         return data;
112 }



188 struct dentry *aa_fs_null;
189 struct vfsmount *aa_fs_mnt;

You can add "static" to these variables and



232                 aafs_remove("profiles");

This entry is never created because aafs_create("profiles") is not called.



Regarding audit.c

 98  * convert to LSM audit

Already converted to LSM audit.



104 /**
105  * audit_base - core AppArmor function.
106  * @ab: audit buffer to fill
107  * @sa: audit structure containing data to audit
108  *
109  * Record common AppArmor audit data from @sa
110  */
111 static void audit_pre(struct audit_buffer *ab, void *ca)

Needs to sync description.



Regarding domain.c

630                 if (!hat) {
631                         if (!COMPLAIN_MODE(root) || permtest) {
632                                 info = "hat not found";
633                                 if (list_empty(&root->base.profiles))
634                                         error = -ECHILD;
635                                 else
636                                         error = -ENOENT;
637                                 goto out;

Setting "info" is useless if "goto out" is what you meant.

638                         }



Regarding file.c

 56         *m++ = '\0';

You don't need "++" here because this is the terminator.



222 /**
223  * aa_str_perms - find permission that match @name
224  * @dfa: to match against  (NOT NULL)
225  * @state: state to start matching in
226  * @name: string to match against dfa  (NOT NULL)
227  * @cond: conditions to consider for permission set computation  (NOT NULL)
228  * @perms: Returns - the permissions found when matching @name
229  *
230  * Returns: the final state in @dfa when beginning @start and walking @name
231  */
232 unsigned int aa_str_perms(struct aa_dfa *dfa, unsigned int start,
233                           const char *name, struct path_cond *cond,
234                           struct file_perms *perms)
235 {
236         unsigned int state;
237         if (!dfa) {

Comment says dfa != NULL.

238                 *perms = nullperms;
239                 return DFA_NOMATCH;
240         }



Regarding ipc.c

 52 /**
 53  * aa_may_ptrace - test if tracer task can trace the tracee
 54  * @tracer_task: task who will do the tracing  (NOT NULL)
 55  * @tracer: profile of the task doing the tracing  (NOT NULL)
 56  * @tracee: task to be traced
 57  * @mode: whether PTRACE_MODE_READ || PTRACE_MODE_ATTACH
 58  *
 59  * Returns: %0 else error code if permission denied or error
 60  */
 61 int aa_may_ptrace(struct task_struct *tracer_task, struct aa_profile *tracer,
 62                   struct aa_profile *tracee, unsigned int mode)
 63 {
 64         /* TODO: currently only based on capability, not extended ptrace
 65          *       rules,
 66          *       Test mode for PTRACE_MODE_READ || PTRACE_MODE_ATTACH
 67          */
 68 
 69         if (!tracer || tracer == tracee)
 70                 return 0;

Comment says tracer != NULL.



Regarding lib.c

 65 bool aa_strneq(const char *str, const char *sub, int len)
 66 {
 67         int res = strncmp(str, sub, len);
 68         if (res)
 69                 return 0;
 70         if (str[len] == 0)
 71                 return 1;
 72         return 0;
 73 }

bool aa_strneq(const char *str, const char *sub, int len)
{
	return !strncmp(str, sub, len) && !str[len];
}

and move to include/apparmor.h as a "static inline" function?



 75 void aa_info_message(const char *str)
 76 {
 77         struct common_audit_data sa;
 78         COMMON_AUDIT_DATA_INIT_NONE(&sa);
 79         sa.aad.info = str,
 80         printk(KERN_INFO "AppArmor: %s\n", str);
 81         if (audit_enabled)
 82                 aa_audit(AUDIT_APPARMOR_STATUS, NULL, GFP_KERNEL, &sa, NULL);
 83 }

void aa_info_message(const char *str)
{
	printk(KERN_INFO "AppArmor: %s\n", str);
	if (audit_enabled) {
		struct common_audit_data sa;
		COMMON_AUDIT_DATA_INIT_NONE(&sa);
		sa.aad.info = str;
		aa_audit(AUDIT_APPARMOR_STATUS, NULL, GFP_KERNEL, &sa, NULL);
	}
}

?



Regarding lsm.c

134 static int apparmor_capable(struct task_struct *task, const struct cred *cred,
135                             int cap, int audit)
136 {
137         struct aa_profile *profile;
138         /* cap_capable returns 0 on success, else -EPERM */
139         int error = cap_capable(task, cred, cap, audit);
140 
141         profile = aa_cred_profile(cred);
142         if (!error  && !unconfined(profile))
143                 error = aa_capable(task, profile, cap, audit);
144 
145         return error;
146 }

static int apparmor_capable(struct task_struct *task, const struct cred *cred,
			    int cap, int audit)
{
	/* cap_capable returns 0 on success, else -EPERM */
	int error = cap_capable(task, cred, cap, audit);

	if (!error) {
		struct aa_profile *profile;
		profile = aa_cred_profile(cred);
	  	if (!unconfined(profile))
			error = aa_capable(task, profile, cap, audit);
	}
	return error;
}

?



148 static int apparmor_sysctl(struct ctl_table *table, int sysctl_op)
149 {

I think you can use security_dentry_open() like TOMOYO does.



578 static int apparmor_setprocattr(struct task_struct *task, char *name,
579                                 void *value, size_t size)
580 {
581         char *command, *args;
582         size_t arg_size;
583         int error;
584 
585         if (size == 0 || size >= PAGE_SIZE)
586                 return -EINVAL;

If value[PAGE_SIZE - 1] == '\0', I think it is OK to accept size == PAGE_SIZE
(provided that you skip "args[size] = '\0';" when size == PAGE_SIZE).
Also, size > PAGE_SIZE is always false because proc_pid_attr_write() truncates
at PAGE_SIZE position.

587 
588         /* task can only write its own attributes */
589         if (current != task)
590                 return -EACCES;
591 
592         args = value;
593         args[size] = '\0';



Regarding match.c

 89         tsize = table_size(th.td_lolen, th.td_flags);
 90         if (bsize < tsize)
 91                 goto out;
 92 
 93         /* freed by free_table */
 94         if (tize <= (16*PAGE_SIZE))
 95                 table = kmalloc(table_alloc_size(tsize),
 96                                 GFP_NOIO | __GFP_NOWARN);
 97         if (!table) {
 98                 table = vmalloc(tsize);
 99                 if (table)
100                         unmap_alias = 1;
101         }

This is bad when tsize < sizeof(struct work_struct) &&
kmalloc() failed and vmalloc() succeeded because
free_table() assumes tsize >= sizeof(struct work_struct) for
vmalloc()ed memory.



206 static void dfa_free(struct aa_dfa *dfa)
207 {
208         if (dfa) {
209                 int i;
210 
211                 for (i = 0; i < ARRAY_SIZE(dfa->tables); i++) {
212                         free_table(dfa->tables[i]);
213                         dfa->tables[i] = NULL;
214                 }
215         }
216         kfree(dfa);

You can move kfree(dfa); to inside { } because kfree(NULL) is redundant.

217 }



Regarding path.c

148 static int get_name_to_buffer(struct path *path, int flags, char *buffer,
149                               int size, char **name)
150 {
151         int adjust = (flags & PATH_IS_DIR) ? 1 : 0;
152         int error = d_namespace_path(path, buffer, size - adjust, name, flags);
153 
154         if (!error && (flags & PATH_IS_DIR) && (*name)[1] != '\0')

	if (!error && adjust && (*name)[1] != '\0')



219 char *sysctl_pathname(struct ctl_table *table, char *buffer, int buflen)

This will become unused when apparmor_sysctl() is removed.



Regarding policy.c

622 void aa_free_root_ns(void)

You can add "__init".



Regarding procattr.c

113 int aa_setprocattr_changehat(char *args, size_t size, int test)
114 {
115         char *hat;
116         u64 token;
117         const char *hats[16];           /* current hard limit on # of names */
118         int count = 0;
119 
120         hat = split_token_from_name(OP_CHANGE_HAT, args, &token);
121         if (IS_ERR(hat))
122                 return PTR_ERR(hat);
123 
124         if (!hat && !token) {
125                 AA_ERROR("change_hat: Invalid input, NULL hat and NULL magic");
126                 return -EINVAL;
127         }
128 
129         if (hat) {
130                 /* set up hat name vector, args guarenteed null terminated
131                  * at args[size]
132                  */
133                 char *end = args + size;
134                 for (count = 0; (hat < end) && count < 16; ++count) {
135                         char *next = hat + strlen(hat) + 1;

Where was "hat" tokenized by '\0'? It seems that hats[1..15] == NULL.

136                         hats[count] = hat;
137                         hat = next;
138                 }
139         }



Regarding include/apparmor.h

 67 static inline unsigned int aa_dfa_null_transition(struct aa_dfa *dfa,
 68                                                   unsigned int start)
 69 {
 70         return aa_dfa_match_len(dfa, start, "\0", 1);
 71 }

You can use "" instead of "\0".



Regarding include/policy.h

 35 #define COMPLAIN_MODE(_profile)                         \
 36         ((aa_g_profile_mode == APPARMOR_COMPLAIN) || ((_profile) &&     \
 37                                         (_profile)->mode == APPARMOR_COMPLAIN))
 38 
 39 #define DO_KILL(_profile)                                       \
 40         ((aa_g_profile_mode == APPARMOR_KILL) || ((_profile) && \
 41                                         (_profile)->mode == APPARMOR_KILL))
 42 
 43 #define PROFILE_IS_HAT(_profile) \
 44         ((_profile) && (_profile)->flags & PFLAG_HAT)

Do these still need _profile != NULL check?



301 static inline int AUDIT_MODE(struct aa_profile *profile)
302 {
303         if (aa_g_audit != AUDIT_NORMAL)
304                 return aa_g_audit;
305         if (profile)
306                 return profile->audit;
307         return AUDIT_NORMAL;
308 }

Can profile == NULL happen?
