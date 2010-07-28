Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab0G1Gsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:48:31 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:61659 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab0G1Gs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:48:29 -0400
To: john.johansen@canonical.com, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [AppArmor #6 0/13] AppArmor security module
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1280199468-19680-1-git-send-email-john.johansen@canonical.com>
In-Reply-To: <1280199468-19680-1-git-send-email-john.johansen@canonical.com>
Message-Id: <201007281548.HFC39035.LHMFOFtJOFVQOS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 28 Jul 2010 15:48:22 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Johansen wrote:
> With this submission we believe AppArmor is ready for inclusion into
> the kernel.
If nobody has objection, I think it is time to add AppArmor for Linux 2.6.36.



LXR as of 9788eb59 "AppArmor: Remove delegate information from permission struct"
is at http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/?v=apparmor-dev .

Comments listed below. All trivial.



Regarding apparmorfs.c

142 static struct dentry *aa_fs_dentry;

You can add "__initdata".

static void aafs_remove(const char *name)

You can add "__init".

163 static int aafs_create(const char *name, int mask,
164                        const struct file_operations *fops)

You can add "__init".

179 void aa_destroy_aafs(void)

You can add "__init".

198 int aa_create_aafs(void)

You can add "static" and "__init".



Regarding audit.c

179 int aa_audit(int type, struct aa_profile *profile, gfp_t gfp,
180              struct common_audit_data *sa,
181              void (*cb) (struct audit_buffer *, void *))
182 {
183         BUG_ON(!profile);
(...snipped...)
200         if (profile && KILL_MODE(profile) && type == AUDIT_APPARMOR_DENIED)
201                 type = AUDIT_APPARMOR_KILL;
202 
203         if (profile && !unconfined(profile))
204                 sa->aad.profile = profile;

profile != NULL already chedked.



Regarding capability.c

 59  * Returns: 0 or sa->error on succes,  error code on failure

s/succes/success/



Regarding domain.c

201  * Either the profile or namespace name may be optional but if the namespace
202  * is specified the profile name termination must be present.  This results
203  * in the following possible encodings:
204  * profile_name\0
205  * :ns_name\0profile_name\0
206  * :ns_name\0\0
207  *
208  * NOTE: the xtable fqname is prevalidated at load time in unpack_trans_table
209  *
210  * Returns: profile name if it is specified else NULL
211  */
212 static const char *separate_fqname(const char *fqname, const char **ns_name)
213 {
214         const char *name;
215 
216         if (fqname[0] == ':') {
217                 *ns_name = fqname + 1;          /* skip : */

Maybe

	BUG_ON(!*ns_name);

or something is wanted in case fqname by error received ':' + '\0' rather than
':' + '\0' + '\0'.

218                 name = *ns_name + strlen(*ns_name) + 1;
219                 if (!*name)
220                         name = NULL;



Regarding lib.c

 61 void aa_info_message(const char *str)
 62 {
 63         if (audit_enabled) {
 64                 struct common_audit_data sa;
 65                 COMMON_AUDIT_DATA_INIT(&sa, NONE);
 66                 sa.aad.info = str;
 67                 printk(KERN_INFO "AppArmor: %s\n", str);

You want to skip printk() if !audit_enabled?

 68                 aa_audit_msg(AUDIT_APPARMOR_STATUS, &sa, NULL);
 69         }
 70 }

 81 void *kvmalloc(size_t size)
 82 {
 83         void *buffer = NULL;
 84 
 85         if (size == 0)
 86                 return NULL;
 87 
 88         /* do not attempt kmalloc if we need more than 16 pages at once */
 89         if (size <= (16*PAGE_SIZE))
 90                 buffer = kmalloc(size, GFP_NOIO | __GFP_NOWARN);
 91         if (!buffer) {

Please add "/* See kvfree() for reason to round up. */" or something.

 92                 if (size < sizeof(struct work_struct))
 93                         size = sizeof(struct work_struct);
 94                 buffer = vmalloc(size);



Regarding lsm.c

 39 int apparmor_initialized;

You can add "__initdata".



Regarding policy_unpack.c

361  * Returns: 1 if table succesfully unpacked

s/succesfully/successfully/



Regarding include/apparmor.h

 50 extern int apparmor_initialized;

You can add "__initdata".



Regarding include/apparmorfs.h

 18 extern void aa_destroy_aafs(void);

You can add "__init".



Regarding include/policy.h

 71 #define AA_NEW_SID 0

This symbol is not used.

254  * @profile: the profile to check for newer versions of (NOT NULL)
(...snipped...)
263 static inline struct aa_profile *aa_newest_version(struct aa_profile *profile)
264 {
265         if (unlikely(profile && profile->replacedby))
266                 for (; profile->replacedby; profile = profile->replacedby)

Comment says profile != NULL. Maybe

static inline struct aa_profile *aa_newest_version(struct aa_profile *profile)
{
	while (profile->replacedby)
		profile = profile->replacedby;
}

?
