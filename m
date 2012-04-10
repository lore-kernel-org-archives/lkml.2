Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab2DJUVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:21:48 -0400
Received: from nm10.access.bullet.mail.mud.yahoo.com ([66.94.237.211]:41301
	"HELO nm10.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756864Ab2DJUVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:21:43 -0400
X-Yahoo-Newman-Id: 705570.20146.bm@smtp104.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0vx_13oVM1kIjuAYkI1PDfoqigZE9enPLWoExBLKQwHsnQg
 RMsqT7MNAgrZpU6cxw3BpmaNRAJxZG8pWB9selkHtnsT8XsKZTqRVB5gufwN
 TIjWuuINffN6_cUxysvRuNo2ZYga2C6ql_abDY8IR2Mw7OorOPVE8YKGcEoQ
 Y20qS53bskYQpY298sKGQgFLRG3viDhbA9OctK99uWsz8dtkP2VX6VicEq6l
 74QTBpk93y22oPipn_MeaMWiro66J97lTWxdavnWLXFexT_HLDZL1aePjJ9m
 VlgR8Fa682jZSr.J5O92CFOgtpM8bamrWk.NEukoeHKpvh.JQxGUZljj0agS
 5c44KSFtya7h346DTNYOlrff7jG_sos6AAEFfhPqwcabJT.6ZBG.lNsU.nTN
 dZ5.kIgSKp_NNB5NutORj_85ESfFBwhnrzLmvGugxpRzShIWah4dGn9J46Ti
 1o79.8LNTQdBy2r1IM_DuOKrXQlK95cOlnxehic0tnIK6Tnfx
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4F849653.1030608@schaufler-ca.com>
Date: Tue, 10 Apr 2012 13:21:39 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: allow for significantly longer Smack labels v3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


V3 incorporates suggestions from
Tetsuo Handa <penguin-kernel@I-love-SAKURA.ne.jp>
Targeted for git://gitorious.org/smack-next/kernel.git

Modern application runtime environments like to use
naming schemes that are structured and generated without
human intervention. Even though the Smack limit of 23
characters for a label name is perfectly rational for
human use there have been complaints that the limit is
a problem in environments where names are composed from
a set or sources, including vendor, author, distribution
channel and application name. Names like

	softwarehouse-pgwodehouse-coolappstore-mellowmuskrats

are becoming harder to avoid. This patch introduces long
label support in Smack. Labels are now limited to 255
characters instead of the old 23.

The primary reason for limiting the labels to 23 characters
was so they could be directly contained in CIPSO category sets.
This is still done were possible, but for labels that are too
large a mapping is required. This is perfectly safe for communication
that stays "on the box" and doesn't require much coordination
between boxes beyond what would have been required to keep label
names consistent.

The bulk of this patch is in smackfs, adding and updating
administrative interfaces. Because existing APIs can't be
changed new ones that do much the same things as old ones
have been introduced.

The Smack specific CIPSO data representation has been removed
and replaced with the data format used by netlabel. The CIPSO
header is now computed when a label is imported rather than
on use. This results in improved IP performance. The smack
label is now allocated separately from the containing structure,
allowing for larger strings. 

Four new /smack interfaces have been introduced as four
of the old interfaces strictly required labels be specified
in fixed length arrays.

The access interface is supplemented with the check interface:
	access  "Subject                 Object                  rwxat"
	access2 "Subject Object rwaxt"

The load interface is supplemented with the rules interface:
	load   "Subject                 Object                  rwxat"
	load2  "Subject Object rwaxt"

The load-self interface is supplemented with the self-rules interface:
	load-self   "Subject                 Object                  rwxat"
	load-self2  "Subject Object rwaxt"

The cipso interface is supplemented with the wire interface:
	cipso  "Subject                  lvl cnt  c1  c2 ..."
	cipso2 "Subject lvl cnt  c1  c2 ..."

The old interfaces are maintained for compatibility.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 Documentation/security/Smack.txt |  204 +++++++--
 security/smack/smack.h           |   56 +--
 security/smack/smack_access.c    |  233 +++++-----
 security/smack/smack_lsm.c       |  186 ++------
 security/smack/smackfs.c         |  993 +++++++++++++++++++++++++++++---------
 5 files changed, 1107 insertions(+), 565 deletions(-)

diff --git a/Documentation/security/Smack.txt b/Documentation/security/Smack.txt
index e9dab41..ec26870 100644
--- a/Documentation/security/Smack.txt
+++ b/Documentation/security/Smack.txt
@@ -15,7 +15,7 @@ at hand.
 
 Smack consists of three major components:
     - The kernel
-    - A start-up script and a few modified applications
+    - Basic utilities, which are helpful but not required
     - Configuration data
 
 The kernel component of Smack is implemented as a Linux
@@ -23,37 +23,28 @@ Security Modules (LSM) module. It requires netlabel and
 works best with file systems that support extended attributes,
 although xattr support is not strictly required.
 It is safe to run a Smack kernel under a "vanilla" distribution.
+
 Smack kernels use the CIPSO IP option. Some network
 configurations are intolerant of IP options and can impede
 access to systems that use them as Smack does.
 
-The startup script etc-init.d-smack should be installed
-in /etc/init.d/smack and should be invoked early in the
-start-up process. On Fedora rc5.d/S02smack is recommended.
-This script ensures that certain devices have the correct
-Smack attributes and loads the Smack configuration if
-any is defined. This script invokes two programs that
-ensure configuration data is properly formatted. These
-programs are /usr/sbin/smackload and /usr/sin/smackcipso.
-The system will run just fine without these programs,
-but it will be difficult to set access rules properly.
-
-A version of "ls" that provides a "-M" option to display
-Smack labels on long listing is available.
+The current git repositories for Smack user space are:
 
-A hacked version of sshd that allows network logins by users
-with specific Smack labels is available. This version does
-not work for scp. You must set the /etc/ssh/sshd_config
-line:
-   UsePrivilegeSeparation no
+	git@gitorious.org:meego-platform-security/smackutil.git
+	git@gitorious.org:meego-platform-security/libsmack.git
 
-The format of /etc/smack/usr is:
+These should make and install on most modern distributions.
+There are three commands included in smackutil:
 
-   username smack
+smackload  - properly formats data for writing to /smack/load
+smackcipso - properly formats data for writing to /smack/cipso
+chsmack    - display or set Smack extended attribute values
 
 In keeping with the intent of Smack, configuration data is
 minimal and not strictly required. The most important
 configuration step is mounting the smackfs pseudo filesystem.
+If smackutil is installed the startup script will take care
+of this, but it can be manually as well.
 
 Add this line to /etc/fstab:
 
@@ -61,19 +52,148 @@ Add this line to /etc/fstab:
 
 and create the /smack directory for mounting.
 
-Smack uses extended attributes (xattrs) to store file labels.
-The command to set a Smack label on a file is:
+Smack uses extended attributes (xattrs) to store labels on filesystem
+objects. The attributes are stored in the extended attribute security
+name space. A process must have CAP_MAC_ADMIN to change any of these
+attributes.
+
+The extended attributes that Smack uses are:
+
+SMACK64
+	Used to make access control decisions. In almost all cases
+	the label given to a new filesystem object will be the label
+	of the process that created it.
+SMACK64EXEC
+	The Smack label of a process that execs a program file with
+	this attribute set will run with this attribute's value.
+SMACK64MMAP
+	Don't allow the file to be mmapped by a process whose Smack
+	label does not allow all of the access permitted to a process
+	with the label contained in this attribute. This is a very
+	specific use case for shared libraries.
+SMACK64TRANSMUTE
+	Can only have the value "TRUE". If this attribute is present
+	on a directory when an object is created in the directory and
+	the Smack rule (more below) that permitted the write access
+	to the directory includes the transmute ("t") mode the object
+	gets the label of the directory instead of the label of the
+	creating process. If the object being created is a directory
+	the SMACK64TRANSMUTE attribute is set as well.
+SMACK64IPIN
+	This attribute is only available on file descriptors for sockets.
+	Use the Smack label in this attribute for access control
+	decisions on packets being delivered to this socket.
+SMACK64IPOUT
+	This attribute is only available on file descriptors for sockets.
+	Use the Smack label in this attribute for access control
+	decisions on packets coming from this socket.
+
+There are multiple ways to set a Smack label on a file:
 
     # attr -S -s SMACK64 -V "value" path
+    # chsmack -a value path
 
-NOTE: Smack labels are limited to 23 characters. The attr command
-      does not enforce this restriction and can be used to set
-      invalid Smack labels on files.
-
-If you don't do anything special all users will get the floor ("_")
-label when they log in. If you do want to log in via the hacked ssh
-at other labels use the attr command to set the smack value on the
-home directory and its contents.
+A process can see the smack label it is running with by
+reading /proc/self/attr/current. A process with CAP_MAC_ADMIN
+can set the process smack by writing there.
+
+Most Smack configuration is accomplished by writing to files
+in the smackfs filesystem. This pseudo-filesystem is usually
+mounted on /smack.
+
+access
+	This interface reports whether a subject with the specified
+	Smack label has a particular access to an object with a
+	specified Smack label. Write a fixed format access rule to
+	this file. The next read will indicate whether the access
+	would be permitted. The text will be either "1" indicating
+	access, or "0" indicating denial.
+access2
+	This interface reports whether a subject with the specified
+	Smack label has a particular access to an object with a
+	specified Smack label. Write a long format access rule to
+	this file. The next read will indicate whether the access
+	would be permitted. The text will be either "1" indicating
+	access, or "0" indicating denial.
+ambient
+	This contains the Smack label applied to unlabeled network
+	packets.
+cipso
+	This interface allows a specific CIPSO header to be assigned
+	to a Smack label. The format accepted on write is:
+		"%24s%4d%4d"["%4d"]...
+	The first string is a fixed Smack label. The first number is
+	the level to use. The second number is the number of categories.
+	The following numbers are the categories.
+	"level-3-cats-5-19          3   2   5  19"
+cipso2
+	This interface allows a specific CIPSO header to be assigned
+	to a Smack label. The format accepted on write is:
+	"%s%4d%4d"["%4d"]...
+	The first string is a long Smack label. The first number is
+	the level to use. The second number is the number of categories.
+	The following numbers are the categories.
+	"level-3-cats-5-19   3   2   5  19"
+direct
+	This contains the CIPSO level used for Smack direct label
+	representation in network packets.
+doi
+	This contains the CIPSO domain of interpretation used in
+	network packets.
+load
+	This interface allows access control rules in addition to
+	the system defined rules to be specified. The format accepted
+	on write is:
+		"%24s%24s%5s"
+	where the first string is the subject label, the second the
+	object label, and the third the requested access. The access
+	string may contain only the characters "rwxat-", and specifies
+	which sort of access is allowed. The "-" is a placeholder for
+	permissions that are not allowed. The string "r-x--" would
+	specify read and execute access. Labels are limited to 23
+	characters in length.
+load2
+	This interface allows access control rules in addition to
+	the system defined rules to be specified. The format accepted
+	on write is:
+		"%s %s %s"
+	where the first string is the subject label, the second the
+	object label, and the third the requested access. The access
+	string may contain only the characters "rwxat-", and specifies
+	which sort of access is allowed. The "-" is a placeholder for
+	permissions that are not allowed. The string "r-x--" would
+	specify read and execute access.
+load-self
+	This interface allows process specific access rules to be
+	defined. These rules are only consulted if access would
+	otherwise be permitted, and are intended to provide additional
+	restrictions on the process. The format is the same as for
+	the load interface.
+load-self2
+	This interface allows process specific access rules to be
+	defined. These rules are only consulted if access would
+	otherwise be permitted, and are intended to provide additional
+	restrictions on the process. The format is the same as for
+	the load2 interface.
+logging
+	This contains the Smack logging state.
+mapped
+	This contains the CIPSO level used for Smack mapped label
+	representation in network packets.
+netlabel
+	This interface allows specific internet addresses to be
+	treated as single label hosts. Packets are sent to single
+	label hosts without CIPSO headers, but only from processes
+	that have Smack write access to the host label. All packets
+	received from single label hosts are given the specified
+	label. The format accepted on write is:
+		"%d.%d.%d.%d label" or "%d.%d.%d.%d/%d label".
+onlycap
+	This contains the label processes must have for CAP_MAC_ADMIN
+	and CAP_MAC_OVERRIDE to be effective. If this file is empty
+	these capabilities are effective at for processes with any
+	label. The value is set by writing the desired label to the
+	file or cleared by writing "-" to the file.
 
 You can add access rules in /etc/smack/accesses. They take the form:
 
@@ -83,10 +203,6 @@ access is a combination of the letters rwxa which specify the
 kind of access permitted a subject with subjectlabel on an
 object with objectlabel. If there is no rule no access is allowed.
 
-A process can see the smack label it is running with by
-reading /proc/self/attr/current. A privileged process can
-set the process smack by writing there.
-
 Look for additional programs on http://schaufler-ca.com
 
 From the Smack Whitepaper:
@@ -186,7 +302,7 @@ team. Smack labels are unstructured, case sensitive, and the only operation
 ever performed on them is comparison for equality. Smack labels cannot
 contain unprintable characters, the "/" (slash), the "\" (backslash), the "'"
 (quote) and '"' (double-quote) characters.
-Smack labels cannot begin with a '-', which is reserved for special options.
+Smack labels cannot begin with a '-'. This is reserved for special options.
 
 There are some predefined labels:
 
@@ -194,7 +310,7 @@ There are some predefined labels:
 	^ 	Pronounced "hat", a single circumflex character.
 	* 	Pronounced "star", a single asterisk character.
 	? 	Pronounced "huh", a single question mark character.
-	@ 	Pronounced "Internet", a single at sign character.
+	@ 	Pronounced "web", a single at sign character.
 
 Every task on a Smack system is assigned a label. System tasks, such as
 init(8) and systems daemons, are run with the floor ("_") label. User tasks
@@ -246,13 +362,14 @@ The format of an access rule is:
 
 Where subject-label is the Smack label of the task, object-label is the Smack
 label of the thing being accessed, and access is a string specifying the sort
-of access allowed. The Smack labels are limited to 23 characters. The access
-specification is searched for letters that describe access modes:
+of access allowed. The access specification is searched for letters that
+describe access modes:
 
 	a: indicates that append access should be granted.
 	r: indicates that read access should be granted.
 	w: indicates that write access should be granted.
 	x: indicates that execute access should be granted.
+	t: indicates that the rule requests transmutation.
 
 Uppercase values for the specification letters are allowed as well.
 Access mode specifications can be in any order. Examples of acceptable rules
@@ -273,7 +390,7 @@ Examples of unacceptable rules are:
 
 Spaces are not allowed in labels. Since a subject always has access to files
 with the same label specifying a rule for that case is pointless. Only
-valid letters (rwxaRWXA) and the dash ('-') character are allowed in
+valid letters (rwxatRWXAT) and the dash ('-') character are allowed in
 access specifications. The dash is a placeholder, so "a-r" is the same
 as "ar". A lone dash is used to specify that no access should be allowed.
 
@@ -297,6 +414,13 @@ but not any of its attributes by the circumstance of having read access to the
 containing directory but not to the differently labeled file. This is an
 artifact of the file name being data in the directory, not a part of the file.
 
+If a directory is marked as transmuting (SMACK64TRANSMUTE=TRUE) and the
+access rule that allows a process to create an object in that directory
+includes 't' access the label assigned to the new object will be that
+of the directory, not the creating process. This makes it much easier
+for two processes with different labels to share data without granting
+access to all of their files.
+
 IPC objects, message queues, semaphore sets, and memory segments exist in flat
 namespaces and access requests are only required to match the object in
 question.
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 49e6ee2..00664ba 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -23,13 +23,19 @@
 #include <linux/lsm_audit.h>
 
 /*
+ * Smack labels were limited to 23 characters for a long time.
+ */
+#define SMK_LABELLEN	24
+#define SMK_LONGLABEL	256
+
+/*
+ * Maximum number of bytes for the levels in a CIPSO IP option.
  * Why 23? CIPSO is constrained to 30, so a 32 byte buffer is
  * bigger than can be used, and 24 is the next lower multiple
  * of 8, and there are too many issues if there isn't space set
  * aside for the terminating null byte.
  */
-#define SMK_MAXLEN	23
-#define SMK_LABELLEN	(SMK_MAXLEN+1)
+#define SMK_CIPSOLEN	24
 
 struct superblock_smack {
 	char		*smk_root;
@@ -79,15 +85,6 @@ struct smack_rule {
 };
 
 /*
- * An entry in the table mapping smack values to
- * CIPSO level/category-set values.
- */
-struct smack_cipso {
-	int	smk_level;
-	char	smk_catset[SMK_LABELLEN];
-};
-
-/*
  * An entry in the table identifying hosts.
  */
 struct smk_netlbladdr {
@@ -114,22 +111,19 @@ struct smk_netlbladdr {
  * interfaces don't. The secid should go away when all of
  * these components have been repaired.
  *
- * If there is a cipso value associated with the label it
- * gets stored here, too. This will most likely be rare as
- * the cipso direct mapping in used internally.
+ * The cipso value associated with the label gets stored here, too.
  *
  * Keep the access rules for this subject label here so that
  * the entire set of rules does not need to be examined every
  * time.
  */
 struct smack_known {
-	struct list_head	list;
-	char			smk_known[SMK_LABELLEN];
-	u32			smk_secid;
-	struct smack_cipso	*smk_cipso;
-	spinlock_t		smk_cipsolock;	/* for changing cipso map */
-	struct list_head	smk_rules;	/* access rules */
-	struct mutex		smk_rules_lock;	/* lock for the rules */
+	struct list_head		list;
+	char				*smk_known;
+	u32				smk_secid;
+	struct netlbl_lsm_secattr	smk_netlabel;	/* on wire labels */
+	struct list_head		smk_rules;	/* access rules */
+	struct mutex			smk_rules_lock;	/* lock for rules */
 };
 
 /*
@@ -166,6 +160,7 @@ struct smack_known {
 #define SMACK_CIPSO_DOI_DEFAULT		3	/* Historical */
 #define SMACK_CIPSO_DOI_INVALID		-1	/* Not a DOI */
 #define SMACK_CIPSO_DIRECT_DEFAULT	250	/* Arbitrary */
+#define SMACK_CIPSO_MAPPED_DEFAULT	251	/* Also arbitrary */
 #define SMACK_CIPSO_MAXCATVAL		63	/* Bigger gets harder */
 #define SMACK_CIPSO_MAXLEVEL            255     /* CIPSO 2.2 standard */
 #define SMACK_CIPSO_MAXCATNUM           239     /* CIPSO 2.2 standard */
@@ -206,10 +201,9 @@ struct inode_smack *new_inode_smack(char *);
 int smk_access_entry(char *, char *, struct list_head *);
 int smk_access(char *, char *, int, struct smk_audit_info *);
 int smk_curacc(char *, u32, struct smk_audit_info *);
-int smack_to_cipso(const char *, struct smack_cipso *);
-char *smack_from_cipso(u32, char *);
 char *smack_from_secid(const u32);
-void smk_parse_smack(const char *string, int len, char *smack);
+char *smk_parse_smack(const char *string, int len);
+int smk_netlbl_mls(int, char *, struct netlbl_lsm_secattr *, int);
 char *smk_import(const char *, int);
 struct smack_known *smk_import_entry(const char *, int);
 struct smack_known *smk_find_entry(const char *);
@@ -219,6 +213,7 @@ u32 smack_to_secid(const char *);
  * Shared data.
  */
 extern int smack_cipso_direct;
+extern int smack_cipso_mapped;
 extern char *smack_net_ambient;
 extern char *smack_onlycap;
 extern const char *smack_cipso_option;
@@ -230,24 +225,13 @@ extern struct smack_known smack_known_invalid;
 extern struct smack_known smack_known_star;
 extern struct smack_known smack_known_web;
 
+extern struct mutex	smack_known_lock;
 extern struct list_head smack_known_list;
 extern struct list_head smk_netlbladdr_list;
 
 extern struct security_operations smack_ops;
 
 /*
- * Stricly for CIPSO level manipulation.
- * Set the category bit number in a smack label sized buffer.
- */
-static inline void smack_catset_bit(int cat, char *catsetp)
-{
-	if (cat > SMK_LABELLEN * 8)
-		return;
-
-	catsetp[(cat - 1) / 8] |= 0x80 >> ((cat - 1) % 8);
-}
-
-/*
  * Is the directory transmuting?
  */
 static inline int smk_inode_transmutable(const struct inode *isp)
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index cc7cb6e..2e4f1bf 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -19,37 +19,31 @@
 struct smack_known smack_known_huh = {
 	.smk_known	= "?",
 	.smk_secid	= 2,
-	.smk_cipso	= NULL,
 };
 
 struct smack_known smack_known_hat = {
 	.smk_known	= "^",
 	.smk_secid	= 3,
-	.smk_cipso	= NULL,
 };
 
 struct smack_known smack_known_star = {
 	.smk_known	= "*",
 	.smk_secid	= 4,
-	.smk_cipso	= NULL,
 };
 
 struct smack_known smack_known_floor = {
 	.smk_known	= "_",
 	.smk_secid	= 5,
-	.smk_cipso	= NULL,
 };
 
 struct smack_known smack_known_invalid = {
 	.smk_known	= "",
 	.smk_secid	= 6,
-	.smk_cipso	= NULL,
 };
 
 struct smack_known smack_known_web = {
 	.smk_known	= "@",
 	.smk_secid	= 7,
-	.smk_cipso	= NULL,
 };
 
 LIST_HEAD(smack_known_list);
@@ -331,7 +325,7 @@ void smack_log(char *subject_label, char *object_label, int request,
 }
 #endif
 
-static DEFINE_MUTEX(smack_known_lock);
+DEFINE_MUTEX(smack_known_lock);
 
 /**
  * smk_find_entry - find a label on the list, return the list entry
@@ -345,7 +339,7 @@ struct smack_known *smk_find_entry(const char *string)
 	struct smack_known *skp;
 
 	list_for_each_entry_rcu(skp, &smack_known_list, list) {
-		if (strncmp(skp->smk_known, string, SMK_MAXLEN) == 0)
+		if (strcmp(skp->smk_known, string) == 0)
 			return skp;
 	}
 
@@ -356,27 +350,76 @@ struct smack_known *smk_find_entry(const char *string)
  * smk_parse_smack - parse smack label from a text string
  * @string: a text string that might contain a Smack label
  * @len: the maximum size, or zero if it is NULL terminated.
- * @smack: parsed smack label, or NULL if parse error
+ *
+ * Returns a pointer to the clean label, or NULL
  */
-void smk_parse_smack(const char *string, int len, char *smack)
+char *smk_parse_smack(const char *string, int len)
 {
-	int found;
+	char *smack;
 	int i;
 
-	if (len <= 0 || len > SMK_MAXLEN)
-		len = SMK_MAXLEN;
-
-	for (i = 0, found = 0; i < SMK_LABELLEN; i++) {
-		if (found)
-			smack[i] = '\0';
-		else if (i >= len || string[i] > '~' || string[i] <= ' ' ||
-			 string[i] == '/' || string[i] == '"' ||
-			 string[i] == '\\' || string[i] == '\'') {
-			smack[i] = '\0';
-			found = 1;
-		} else
-			smack[i] = string[i];
+	if (len <= 0)
+		len = strlen(string) + 1;
+
+	/*
+	 * Reserve a leading '-' as an indicator that
+	 * this isn't a label, but an option to interfaces
+	 * including /smack/cipso and /smack/cipso2
+	 */
+	if (string[0] == '-')
+		return NULL;
+
+	for (i = 0; i < len; i++)
+		if (string[i] > '~' || string[i] <= ' ' || string[i] == '/' ||
+		    string[i] == '"' || string[i] == '\\' || string[i] == '\'')
+			break;
+
+	if (i == 0 || i >= SMK_LONGLABEL)
+		return NULL;
+
+	smack = kzalloc(i + 1, GFP_KERNEL);
+	if (smack != NULL) {
+		strncpy(smack, string, i + 1);
+		smack[i] = '\0';
 	}
+	return smack;
+}
+
+/**
+ * smk_netlbl_mls - convert a catset to netlabel mls categories
+ * @catset: the Smack categories
+ * @sap: where to put the netlabel categories
+ *
+ * Allocates and fills attr.mls
+ * Returns 0 on success, error code on failure.
+ */
+int smk_netlbl_mls(int level, char *catset, struct netlbl_lsm_secattr *sap,
+			int len)
+{
+	unsigned char *cp;
+	unsigned char m;
+	int cat;
+	int rc;
+	int byte;
+
+	sap->flags |= NETLBL_SECATTR_MLS_CAT;
+	sap->attr.mls.lvl = level;
+	sap->attr.mls.cat = netlbl_secattr_catmap_alloc(GFP_ATOMIC);
+	sap->attr.mls.cat->startbit = 0;
+
+	for (cat = 1, cp = catset, byte = 0; byte < len; cp++, byte++)
+		for (m = 0x80; m != 0; m >>= 1, cat++) {
+			if ((m & *cp) == 0)
+				continue;
+			rc = netlbl_secattr_catmap_setbit(sap->attr.mls.cat,
+							  cat, GFP_ATOMIC);
+			if (rc < 0) {
+				netlbl_secattr_catmap_free(sap->attr.mls.cat);
+				return rc;
+			}
+		}
+
+	return 0;
 }
 
 /**
@@ -390,33 +433,59 @@ void smk_parse_smack(const char *string, int len, char *smack)
 struct smack_known *smk_import_entry(const char *string, int len)
 {
 	struct smack_known *skp;
-	char smack[SMK_LABELLEN];
+	char *smack;
+	int slen;
+	int rc;
 
-	smk_parse_smack(string, len, smack);
-	if (smack[0] == '\0')
+	smack = smk_parse_smack(string, len);
+	if (smack == NULL)
 		return NULL;
 
 	mutex_lock(&smack_known_lock);
 
 	skp = smk_find_entry(smack);
+	if (skp != NULL)
+		goto freeout;
 
-	if (skp == NULL) {
-		skp = kzalloc(sizeof(struct smack_known), GFP_KERNEL);
-		if (skp != NULL) {
-			strncpy(skp->smk_known, smack, SMK_MAXLEN);
-			skp->smk_secid = smack_next_secid++;
-			skp->smk_cipso = NULL;
-			INIT_LIST_HEAD(&skp->smk_rules);
-			spin_lock_init(&skp->smk_cipsolock);
-			mutex_init(&skp->smk_rules_lock);
-			/*
-			 * Make sure that the entry is actually
-			 * filled before putting it on the list.
-			 */
-			list_add_rcu(&skp->list, &smack_known_list);
-		}
-	}
+	skp = kzalloc(sizeof(*skp), GFP_KERNEL);
+	if (skp == NULL)
+		goto freeout;
 
+	skp->smk_known = smack;
+	skp->smk_secid = smack_next_secid++;
+	skp->smk_netlabel.domain = skp->smk_known;
+	skp->smk_netlabel.flags =
+		NETLBL_SECATTR_DOMAIN | NETLBL_SECATTR_MLS_LVL;
+	/*
+	 * If direct labeling works use it.
+	 * Otherwise use mapped labeling.
+	 */
+	slen = strlen(smack);
+	if (slen < SMK_CIPSOLEN)
+		rc = smk_netlbl_mls(smack_cipso_direct, skp->smk_known,
+			       &skp->smk_netlabel, slen);
+	else
+		rc = smk_netlbl_mls(smack_cipso_mapped, (char *)&skp->smk_secid,
+			       &skp->smk_netlabel, sizeof(skp->smk_secid));
+
+	if (rc >= 0) {
+		INIT_LIST_HEAD(&skp->smk_rules);
+		mutex_init(&skp->smk_rules_lock);
+		/*
+		 * Make sure that the entry is actually
+		 * filled before putting it on the list.
+		 */
+		list_add_rcu(&skp->list, &smack_known_list);
+		goto unlockout;
+	}
+	/*
+	 * smk_netlbl_mls failed.
+	 */
+	kfree(skp);
+	skp = NULL;
+freeout:
+	kfree(smack);
+unlockout:
 	mutex_unlock(&smack_known_lock);
 
 	return skp;
@@ -479,79 +548,9 @@ char *smack_from_secid(const u32 secid)
  */
 u32 smack_to_secid(const char *smack)
 {
-	struct smack_known *skp;
+	struct smack_known *skp = smk_find_entry(smack);
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(skp, &smack_known_list, list) {
-		if (strncmp(skp->smk_known, smack, SMK_MAXLEN) == 0) {
-			rcu_read_unlock();
-			return skp->smk_secid;
-		}
-	}
-	rcu_read_unlock();
-	return 0;
-}
-
-/**
- * smack_from_cipso - find the Smack label associated with a CIPSO option
- * @level: Bell & LaPadula level from the network
- * @cp: Bell & LaPadula categories from the network
- *
- * This is a simple lookup in the label table.
- *
- * Return the matching label from the label list or NULL.
- */
-char *smack_from_cipso(u32 level, char *cp)
-{
-	struct smack_known *kp;
-	char *final = NULL;
-
-	rcu_read_lock();
-	list_for_each_entry(kp, &smack_known_list, list) {
-		if (kp->smk_cipso == NULL)
-			continue;
-
-		spin_lock_bh(&kp->smk_cipsolock);
-
-		if (kp->smk_cipso->smk_level == level &&
-		    memcmp(kp->smk_cipso->smk_catset, cp, SMK_LABELLEN) == 0)
-			final = kp->smk_known;
-
-		spin_unlock_bh(&kp->smk_cipsolock);
-
-		if (final != NULL)
-			break;
-	}
-	rcu_read_unlock();
-
-	return final;
-}
-
-/**
- * smack_to_cipso - find the CIPSO option to go with a Smack label
- * @smack: a pointer to the smack label in question
- * @cp: where to put the result
- *
- * Returns zero if a value is available, non-zero otherwise.
- */
-int smack_to_cipso(const char *smack, struct smack_cipso *cp)
-{
-	struct smack_known *kp;
-	int found = 0;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(kp, &smack_known_list, list) {
-		if (kp->smk_known == smack ||
-		    strcmp(kp->smk_known, smack) == 0) {
-			found = 1;
-			break;
-		}
-	}
-	rcu_read_unlock();
-
-	if (found == 0 || kp->smk_cipso == NULL)
-		return -ENOENT;
-
-	memcpy(cp, kp->smk_cipso, sizeof(struct smack_cipso));
-	return 0;
+	if (skp == NULL)
+		return 0;
+	return skp->smk_secid;
 }
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index c9d2fd9..00d8575 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -30,7 +30,6 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/pipe_fs_i.h>
-#include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
 #include <linux/audit.h>
 #include <linux/magic.h>
@@ -57,16 +56,23 @@
 static char *smk_fetch(const char *name, struct inode *ip, struct dentry *dp)
 {
 	int rc;
-	char in[SMK_LABELLEN];
+	char *buffer;
+	char *result = NULL;
 
 	if (ip->i_op->getxattr == NULL)
 		return NULL;
 
-	rc = ip->i_op->getxattr(dp, name, in, SMK_LABELLEN);
-	if (rc < 0)
+	buffer = kzalloc(SMK_LONGLABEL, GFP_KERNEL);
+	if (buffer == NULL)
 		return NULL;
 
-	return smk_import(in, rc);
+	rc = ip->i_op->getxattr(dp, name, buffer, SMK_LONGLABEL);
+	if (rc > 0)
+		result = smk_import(buffer, rc);
+
+	kfree(buffer);
+
+	return result;
 }
 
 /**
@@ -825,7 +831,7 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 		 * check label validity here so import wont fail on
 		 * post_setxattr
 		 */
-		if (size == 0 || size >= SMK_LABELLEN ||
+		if (size == 0 || size >= SMK_LONGLABEL ||
 		    smk_import(value, size) == NULL)
 			rc = -EINVAL;
 	} else if (strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0) {
@@ -1824,65 +1830,6 @@ static char *smack_host_label(struct sockaddr_in *sip)
 }
 
 /**
- * smack_set_catset - convert a capset to netlabel mls categories
- * @catset: the Smack categories
- * @sap: where to put the netlabel categories
- *
- * Allocates and fills attr.mls.cat
- */
-static void smack_set_catset(char *catset, struct netlbl_lsm_secattr *sap)
-{
-	unsigned char *cp;
-	unsigned char m;
-	int cat;
-	int rc;
-	int byte;
-
-	if (!catset)
-		return;
-
-	sap->flags |= NETLBL_SECATTR_MLS_CAT;
-	sap->attr.mls.cat = netlbl_secattr_catmap_alloc(GFP_ATOMIC);
-	sap->attr.mls.cat->startbit = 0;
-
-	for (cat = 1, cp = catset, byte = 0; byte < SMK_LABELLEN; cp++, byte++)
-		for (m = 0x80; m != 0; m >>= 1, cat++) {
-			if ((m & *cp) == 0)
-				continue;
-			rc = netlbl_secattr_catmap_setbit(sap->attr.mls.cat,
-							  cat, GFP_ATOMIC);
-		}
-}
-
-/**
- * smack_to_secattr - fill a secattr from a smack value
- * @smack: the smack value
- * @nlsp: where the result goes
- *
- * Casey says that CIPSO is good enough for now.
- * It can be used to effect.
- * It can also be abused to effect when necessary.
- * Apologies to the TSIG group in general and GW in particular.
- */
-static void smack_to_secattr(char *smack, struct netlbl_lsm_secattr *nlsp)
-{
-	struct smack_cipso cipso;
-	int rc;
-
-	nlsp->domain = smack;
-	nlsp->flags = NETLBL_SECATTR_DOMAIN | NETLBL_SECATTR_MLS_LVL;
-
-	rc = smack_to_cipso(smack, &cipso);
-	if (rc == 0) {
-		nlsp->attr.mls.lvl = cipso.smk_level;
-		smack_set_catset(cipso.smk_catset, nlsp);
-	} else {
-		nlsp->attr.mls.lvl = smack_cipso_direct;
-		smack_set_catset(smack, nlsp);
-	}
-}
-
-/**
  * smack_netlabel - Set the secattr on a socket
  * @sk: the socket
  * @labeled: socket label scheme
@@ -1894,8 +1841,8 @@ static void smack_to_secattr(char *smack, struct netlbl_lsm_secattr *nlsp)
  */
 static int smack_netlabel(struct sock *sk, int labeled)
 {
+	struct smack_known *skp;
 	struct socket_smack *ssp = sk->sk_security;
-	struct netlbl_lsm_secattr secattr;
 	int rc = 0;
 
 	/*
@@ -1913,10 +1860,8 @@ static int smack_netlabel(struct sock *sk, int labeled)
 	    labeled == SMACK_UNLABELED_SOCKET)
 		netlbl_sock_delattr(sk);
 	else {
-		netlbl_secattr_init(&secattr);
-		smack_to_secattr(ssp->smk_out, &secattr);
-		rc = netlbl_sock_setattr(sk, sk->sk_family, &secattr);
-		netlbl_secattr_destroy(&secattr);
+		skp = smk_find_entry(ssp->smk_out);
+		rc = netlbl_sock_setattr(sk, sk->sk_family, &skp->smk_netlabel);
 	}
 
 	bh_unlock_sock(sk);
@@ -1987,7 +1932,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 	struct socket *sock;
 	int rc = 0;
 
-	if (value == NULL || size > SMK_LABELLEN || size == 0)
+	if (value == NULL || size > SMK_LONGLABEL || size == 0)
 		return -EACCES;
 
 	sp = smk_import(value, size);
@@ -2783,7 +2728,7 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
-	if (value == NULL || size == 0 || size >= SMK_LABELLEN)
+	if (value == NULL || size == 0 || size >= SMK_LONGLABEL)
 		return -EINVAL;
 
 	if (strcmp(name, "current") != 0)
@@ -2911,10 +2856,9 @@ static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 static char *smack_from_secattr(struct netlbl_lsm_secattr *sap,
 				struct socket_smack *ssp)
 {
-	struct smack_known *skp;
-	char smack[SMK_LABELLEN];
+	struct smack_known *kp;
 	char *sp;
-	int pcat;
+	int found = 0;
 
 	if ((sap->flags & NETLBL_SECATTR_MLS_LVL) != 0) {
 		/*
@@ -2922,59 +2866,27 @@ static char *smack_from_secattr(struct netlbl_lsm_secattr *sap,
 		 * If there are flags but no level netlabel isn't
 		 * behaving the way we expect it to.
 		 *
-		 * Get the categories, if any
+		 * Look it up in the label table
 		 * Without guidance regarding the smack value
 		 * for the packet fall back on the network
 		 * ambient value.
 		 */
-		memset(smack, '\0', SMK_LABELLEN);
-		if ((sap->flags & NETLBL_SECATTR_MLS_CAT) != 0)
-			for (pcat = -1;;) {
-				pcat = netlbl_secattr_catmap_walk(
-					sap->attr.mls.cat, pcat + 1);
-				if (pcat < 0)
-					break;
-				smack_catset_bit(pcat, smack);
-			}
-		/*
-		 * If it is CIPSO using smack direct mapping
-		 * we are already done. WeeHee.
-		 */
-		if (sap->attr.mls.lvl == smack_cipso_direct) {
-			/*
-			 * The label sent is usually on the label list.
-			 *
-			 * If it is not we may still want to allow the
-			 * delivery.
-			 *
-			 * If the recipient is accepting all packets
-			 * because it is using the star ("*") label
-			 * for SMACK64IPIN provide the web ("@") label
-			 * so that a directed response will succeed.
-			 * This is not very correct from a MAC point
-			 * of view, but gets around the problem that
-			 * locking prevents adding the newly discovered
-			 * label to the list.
-			 * The case where the recipient is not using
-			 * the star label should obviously fail.
-			 * The easy way to do this is to provide the
-			 * star label as the subject label.
-			 */
-			skp = smk_find_entry(smack);
-			if (skp != NULL)
-				return skp->smk_known;
-			if (ssp != NULL &&
-			    ssp->smk_in == smack_known_star.smk_known)
-				return smack_known_web.smk_known;
-			return smack_known_star.smk_known;
+		rcu_read_lock();
+		list_for_each_entry(kp, &smack_known_list, list) {
+			if (sap->attr.mls.lvl != kp->smk_netlabel.attr.mls.lvl)
+				continue;
+			if (memcmp(sap->attr.mls.cat,
+				kp->smk_netlabel.attr.mls.cat,
+				SMK_CIPSOLEN) != 0)
+				continue;
+			found = 1;
+			break;
 		}
-		/*
-		 * Look it up in the supplied table if it is not
-		 * a direct mapping.
-		 */
-		sp = smack_from_cipso(sap->attr.mls.lvl, smack);
-		if (sp != NULL)
-			return sp;
+		rcu_read_unlock();
+
+		if (found)
+			return kp->smk_known;
+
 		if (ssp != NULL && ssp->smk_in == smack_known_star.smk_known)
 			return smack_known_web.smk_known;
 		return smack_known_star.smk_known;
@@ -3171,11 +3083,13 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 				   struct request_sock *req)
 {
 	u16 family = sk->sk_family;
+	struct smack_known *skp;
 	struct socket_smack *ssp = sk->sk_security;
 	struct netlbl_lsm_secattr secattr;
 	struct sockaddr_in addr;
 	struct iphdr *hdr;
 	char *sp;
+	char *hsp;
 	int rc;
 	struct smk_audit_info ad;
 
@@ -3219,16 +3133,14 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	hdr = ip_hdr(skb);
 	addr.sin_addr.s_addr = hdr->saddr;
 	rcu_read_lock();
-	if (smack_host_label(&addr) == NULL) {
-		rcu_read_unlock();
-		netlbl_secattr_init(&secattr);
-		smack_to_secattr(sp, &secattr);
-		rc = netlbl_req_setattr(req, &secattr);
-		netlbl_secattr_destroy(&secattr);
-	} else {
-		rcu_read_unlock();
+	hsp = smack_host_label(&addr);
+	rcu_read_unlock();
+
+	if (hsp == NULL) {
+		skp = smk_find_entry(sp);
+		rc = netlbl_req_setattr(req, &skp->smk_netlabel);
+	} else
 		netlbl_req_delattr(req);
-	}
 
 	return rc;
 }
@@ -3686,16 +3598,10 @@ static __init int smack_init(void)
 	cred = (struct cred *) current->cred;
 	cred->security = tsp;
 
-	/* initialize the smack_know_list */
-	init_smack_know_list();
 	/*
-	 * Initialize locks
+	 * initialize the smack_know_list
 	 */
-	spin_lock_init(&smack_known_huh.smk_cipsolock);
-	spin_lock_init(&smack_known_hat.smk_cipsolock);
-	spin_lock_init(&smack_known_star.smk_cipsolock);
-	spin_lock_init(&smack_known_floor.smk_cipsolock);
-	spin_lock_init(&smack_known_invalid.smk_cipsolock);
+	init_smack_know_list();
 
 	/*
 	 * Register with LSM
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 5c32f36..a74dc72 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -22,7 +22,6 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <net/net_namespace.h>
-#include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
 #include <linux/seq_file.h>
 #include <linux/ctype.h>
@@ -45,6 +44,11 @@ enum smk_inos {
 	SMK_LOGGING	= 10,	/* logging */
 	SMK_LOAD_SELF	= 11,	/* task specific rules */
 	SMK_ACCESSES	= 12,	/* access policy */
+	SMK_MAPPED	= 13,	/* CIPSO level indicating mapped label */
+	SMK_LOAD2	= 14,	/* load policy with long labels */
+	SMK_LOAD_SELF2	= 15,	/* load task specific rules with long labels */
+	SMK_ACCESS2	= 16,	/* make an access check with long labels */
+	SMK_CIPSO2	= 17,	/* load long label -> CIPSO mapping */
 };
 
 /*
@@ -60,7 +64,7 @@ static DEFINE_MUTEX(smk_netlbladdr_lock);
  * If it isn't somehow marked, use this.
  * It can be reset via smackfs/ambient
  */
-char *smack_net_ambient = smack_known_floor.smk_known;
+char *smack_net_ambient;
 
 /*
  * This is the level in a CIPSO header that indicates a
@@ -70,6 +74,13 @@ char *smack_net_ambient = smack_known_floor.smk_known;
 int smack_cipso_direct = SMACK_CIPSO_DIRECT_DEFAULT;
 
 /*
+ * This is the level in a CIPSO header that indicates a
+ * secid is contained directly in the category set.
+ * It can be reset via smackfs/mapped
+ */
+int smack_cipso_mapped = SMACK_CIPSO_MAPPED_DEFAULT;
+
+/*
  * Unless a process is running with this label even
  * having CAP_MAC_OVERRIDE isn't enough to grant
  * privilege to violate MAC policy. If no label is
@@ -89,7 +100,7 @@ LIST_HEAD(smk_netlbladdr_list);
 
 /*
  * Rule lists are maintained for each label.
- * This master list is just for reading /smack/load.
+ * This master list is just for reading /smack/load and /smack/load2.
  */
 struct smack_master_list {
 	struct list_head	list;
@@ -125,6 +136,18 @@ const char *smack_cipso_option = SMACK_CIPSO_OPTION;
 #define SMK_OLOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_OACCESSLEN)
 #define SMK_LOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSLEN)
 
+/*
+ * Stricly for CIPSO level manipulation.
+ * Set the category bit number in a smack label sized buffer.
+ */
+static inline void smack_catset_bit(unsigned int cat, char *catsetp)
+{
+	if (cat == 0 || cat > (SMK_CIPSOLEN * 8))
+		return;
+
+	catsetp[(cat - 1) / 8] |= 0x80 >> ((cat - 1) % 8);
+}
+
 /**
  * smk_netlabel_audit_set - fill a netlbl_audit struct
  * @nap: structure to fill
@@ -137,12 +160,10 @@ static void smk_netlabel_audit_set(struct netlbl_audit *nap)
 }
 
 /*
- * Values for parsing single label host rules
+ * Value for parsing single label host rules
  * "1.2.3.4 X"
- * "192.168.138.129/32 abcdefghijklmnopqrstuvw"
  */
 #define SMK_NETLBLADDRMIN	9
-#define SMK_NETLBLADDRMAX	42
 
 /**
  * smk_set_access - add a rule to the rule list
@@ -188,33 +209,47 @@ static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
 }
 
 /**
- * smk_parse_rule - parse Smack rule from load string
- * @data: string to be parsed whose size is SMK_LOADLEN
+ * smk_fill_rule - Fill Smack rule from strings
+ * @subject: subject label string
+ * @object: object label string
+ * @access: access string
  * @rule: Smack rule
  * @import: if non-zero, import labels
+ *
+ * Returns 0 on success, -1 on failure
  */
-static int smk_parse_rule(const char *data, struct smack_rule *rule, int import)
+static int smk_fill_rule(const char *subject, const char *object,
+				const char *access, struct smack_rule *rule,
+				int import)
 {
-	char smack[SMK_LABELLEN];
+	int rc = -1;
+	int done;
+	const char *cp;
 	struct smack_known *skp;
 
 	if (import) {
-		rule->smk_subject = smk_import(data, 0);
+		rule->smk_subject = smk_import(subject, 0);
 		if (rule->smk_subject == NULL)
 			return -1;
 
-		rule->smk_object = smk_import(data + SMK_LABELLEN, 0);
+		rule->smk_object = smk_import(object, 0);
 		if (rule->smk_object == NULL)
 			return -1;
 	} else {
-		smk_parse_smack(data, 0, smack);
-		skp = smk_find_entry(smack);
+		cp = smk_parse_smack(subject, 0);
+		if (cp == NULL)
+			return -1;
+		skp = smk_find_entry(cp);
+		kfree(cp);
 		if (skp == NULL)
 			return -1;
 		rule->smk_subject = skp->smk_known;
 
-		smk_parse_smack(data + SMK_LABELLEN, 0, smack);
-		skp = smk_find_entry(smack);
+		cp = smk_parse_smack(object, 0);
+		if (cp == NULL)
+			return -1;
+		skp = smk_find_entry(cp);
+		kfree(cp);
 		if (skp == NULL)
 			return -1;
 		rule->smk_object = skp->smk_known;
@@ -222,90 +257,127 @@ static int smk_parse_rule(const char *data, struct smack_rule *rule, int import)
 
 	rule->smk_access = 0;
 
-	switch (data[SMK_LABELLEN + SMK_LABELLEN]) {
-	case '-':
-		break;
-	case 'r':
-	case 'R':
-		rule->smk_access |= MAY_READ;
-		break;
-	default:
-		return -1;
+	for (cp = access, done = 0; *cp && !done; cp++) {
+		switch (*cp) {
+		case '-':
+			break;
+		case 'r':
+		case 'R':
+			rule->smk_access |= MAY_READ;
+			break;
+		case 'w':
+		case 'W':
+			rule->smk_access |= MAY_WRITE;
+			break;
+		case 'x':
+		case 'X':
+			rule->smk_access |= MAY_EXEC;
+			break;
+		case 'a':
+		case 'A':
+			rule->smk_access |= MAY_APPEND;
+			break;
+		case 't':
+		case 'T':
+			rule->smk_access |= MAY_TRANSMUTE;
+			break;
+		default:
+			done = 1;
+			break;
+		}
 	}
+	rc = 0;
 
-	switch (data[SMK_LABELLEN + SMK_LABELLEN + 1]) {
-	case '-':
-		break;
-	case 'w':
-	case 'W':
-		rule->smk_access |= MAY_WRITE;
-		break;
-	default:
-		return -1;
-	}
+	return rc;
+}
 
-	switch (data[SMK_LABELLEN + SMK_LABELLEN + 2]) {
-	case '-':
-		break;
-	case 'x':
-	case 'X':
-		rule->smk_access |= MAY_EXEC;
-		break;
-	default:
-		return -1;
-	}
+/**
+ * smk_parse_rule - parse Smack rule from load string
+ * @data: string to be parsed whose size is SMK_LOADLEN
+ * @rule: Smack rule
+ * @import: if non-zero, import labels
+ *
+ * Returns 0 on success, -1 on errors.
+ */
+static int smk_parse_rule(const char *data, struct smack_rule *rule, int import)
+{
+	int rc;
 
-	switch (data[SMK_LABELLEN + SMK_LABELLEN + 3]) {
-	case '-':
-		break;
-	case 'a':
-	case 'A':
-		rule->smk_access |= MAY_APPEND;
-		break;
-	default:
-		return -1;
-	}
+	rc = smk_fill_rule(data, data + SMK_LABELLEN,
+			   data + SMK_LABELLEN + SMK_LABELLEN, rule, import);
+	return rc;
+}
 
-	switch (data[SMK_LABELLEN + SMK_LABELLEN + 4]) {
-	case '-':
-		break;
-	case 't':
-	case 'T':
-		rule->smk_access |= MAY_TRANSMUTE;
-		break;
-	default:
-		return -1;
-	}
+/**
+ * smk_parse_long_rule - parse Smack rule from rule string
+ * @data: string to be parsed, null terminated
+ * @rule: Smack rule
+ * @import: if non-zero, import labels
+ *
+ * Returns 0 on success, -1 on failure
+ */
+static int smk_parse_long_rule(const char *data, struct smack_rule *rule,
+				int import)
+{
+	char *subject;
+	char *object;
+	char *access;
+	int datalen;
+	int rc = -1;
 
-	return 0;
+	/*
+	 * This is probably inefficient, but safe.
+	 */
+	datalen = strlen(data);
+	subject = kzalloc(datalen, GFP_KERNEL);
+	if (subject == NULL)
+		return -1;
+	object = kzalloc(datalen, GFP_KERNEL);
+	if (object == NULL)
+		goto free_out_s;
+	access = kzalloc(datalen, GFP_KERNEL);
+	if (access == NULL)
+		goto free_out_o;
+
+	if (sscanf(data, "%s %s %s", subject, object, access) == 3)
+		rc = smk_fill_rule(subject, object, access, rule, import);
+
+	kfree(access);
+free_out_o:
+	kfree(object);
+free_out_s:
+	kfree(subject);
+	return rc;
 }
 
+#define SMK_FIXED24_FMT	0	/* Fixed 24byte label format */
+#define SMK_LONG_FMT	1	/* Variable long label format */
 /**
- * smk_write_load_list - write() for any /smack/load
+ * smk_write_rules_list - write() for any /smack rule file
  * @file: file pointer, not actually used
  * @buf: where to get the data from
  * @count: bytes sent
  * @ppos: where to start - must be 0
  * @rule_list: the list of rules to write to
  * @rule_lock: lock for the rule list
+ * @format: /smack/load or /smack/load2 format.
  *
  * Get one smack access rule from above.
- * The format is exactly:
- *     char subject[SMK_LABELLEN]
- *     char object[SMK_LABELLEN]
- *     char access[SMK_ACCESSLEN]
- *
- * writes must be SMK_LABELLEN+SMK_LABELLEN+SMK_ACCESSLEN bytes.
+ * The format for SMK_LONG_FMT is:
+ *	"subject<whitespace>object<whitespace>access[<whitespace>...]"
+ * The format for SMK_FIXED24_FMT is exactly:
+ *	"subject                 object                  rwxat"
  */
-static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
-				size_t count, loff_t *ppos,
-				struct list_head *rule_list,
-				struct mutex *rule_lock)
+static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
+					size_t count, loff_t *ppos,
+					struct list_head *rule_list,
+					struct mutex *rule_lock, int format)
 {
 	struct smack_master_list *smlp;
 	struct smack_known *skp;
 	struct smack_rule *rule;
 	char *data;
+	int datalen;
 	int rc = -EINVAL;
 	int load = 0;
 
@@ -315,13 +387,18 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
 	 */
 	if (*ppos != 0)
 		return -EINVAL;
-	/*
-	 * Minor hack for backward compatibility
-	 */
-	if (count < (SMK_OLOADLEN) || count > SMK_LOADLEN)
-		return -EINVAL;
 
-	data = kzalloc(SMK_LOADLEN, GFP_KERNEL);
+	if (format == SMK_FIXED24_FMT) {
+		/*
+		 * Minor hack for backward compatibility
+		 */
+		if (count != SMK_OLOADLEN && count != SMK_LOADLEN)
+			return -EINVAL;
+		datalen = SMK_LOADLEN;
+	} else
+		datalen = count + 1;
+
+	data = kzalloc(datalen, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -330,20 +407,29 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	/*
-	 * More on the minor hack for backward compatibility
-	 */
-	if (count == (SMK_OLOADLEN))
-		data[SMK_OLOADLEN] = '-';
-
 	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
 	if (rule == NULL) {
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	if (smk_parse_rule(data, rule, 1))
-		goto out_free_rule;
+	if (format == SMK_LONG_FMT) {
+		/*
+		 * Be sure the data string is terminated.
+		 */
+		data[count] = '\0';
+		if (smk_parse_long_rule(data, rule, 1))
+			goto out_free_rule;
+	} else {
+		/*
+		 * More on the minor hack for backward compatibility
+		 */
+		if (count == (SMK_OLOADLEN))
+			data[SMK_OLOADLEN] = '-';
+		if (smk_parse_rule(data, rule, 1))
+			goto out_free_rule;
+	}
+
 
 	if (rule_list == NULL) {
 		load = 1;
@@ -354,18 +440,20 @@ static ssize_t smk_write_load_list(struct file *file, const char __user *buf,
 
 	rc = count;
 	/*
-	 * If this is "load" as opposed to "load-self" and a new rule
+	 * If this is a global as opposed to self and a new rule
 	 * it needs to get added for reporting.
 	 * smk_set_access returns true if there was already a rule
 	 * for the subject/object pair, and false if it was new.
 	 */
-	if (load && !smk_set_access(rule, rule_list, rule_lock)) {
-		smlp = kzalloc(sizeof(*smlp), GFP_KERNEL);
-		if (smlp != NULL) {
-			smlp->smk_rule = rule;
-			list_add_rcu(&smlp->list, &smack_rule_list);
-		} else
-			rc = -ENOMEM;
+	if (!smk_set_access(rule, rule_list, rule_lock)) {
+		if (load) {
+			smlp = kzalloc(sizeof(*smlp), GFP_KERNEL);
+			if (smlp != NULL) {
+				smlp->smk_rule = rule;
+				list_add_rcu(&smlp->list, &smack_rule_list);
+			} else
+				rc = -ENOMEM;
+		}
 		goto out;
 	}
 
@@ -421,29 +509,18 @@ static void smk_seq_stop(struct seq_file *s, void *v)
 	/* No-op */
 }
 
-/*
- * Seq_file read operations for /smack/load
- */
-
-static void *load_seq_start(struct seq_file *s, loff_t *pos)
-{
-	return smk_seq_start(s, pos, &smack_rule_list);
-}
-
-static void *load_seq_next(struct seq_file *s, void *v, loff_t *pos)
+static void smk_rule_show(struct seq_file *s, struct smack_rule *srp, int max)
 {
-	return smk_seq_next(s, v, pos, &smack_rule_list);
-}
-
-static int load_seq_show(struct seq_file *s, void *v)
-{
-	struct list_head *list = v;
-	struct smack_master_list *smlp =
-		 list_entry(list, struct smack_master_list, list);
-	struct smack_rule *srp = smlp->smk_rule;
+	/*
+	 * Don't show any rules with label names too long for
+	 * interface file (/smack/load or /smack/load2)
+	 * because you should expect to be able to write
+	 * anything you read back.
+	 */
+	if (strlen(srp->smk_subject) >= max || strlen(srp->smk_object) >= max)
+		return;
 
-	seq_printf(s, "%s %s", (char *)srp->smk_subject,
-		   (char *)srp->smk_object);
+	seq_printf(s, "%s %s", srp->smk_subject, srp->smk_object);
 
 	seq_putc(s, ' ');
 
@@ -461,13 +538,36 @@ static int load_seq_show(struct seq_file *s, void *v)
 		seq_putc(s, '-');
 
 	seq_putc(s, '\n');
+}
+
+/*
+ * Seq_file read operations for /smack/load
+ */
+
+static void *load2_seq_start(struct seq_file *s, loff_t *pos)
+{
+	return smk_seq_start(s, pos, &smack_rule_list);
+}
+
+static void *load2_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	return smk_seq_next(s, v, pos, &smack_rule_list);
+}
+
+static int load_seq_show(struct seq_file *s, void *v)
+{
+	struct list_head *list = v;
+	struct smack_master_list *smlp =
+		 list_entry(list, struct smack_master_list, list);
+
+	smk_rule_show(s, smlp->smk_rule, SMK_LABELLEN);
 
 	return 0;
 }
 
 static const struct seq_operations load_seq_ops = {
-	.start = load_seq_start,
-	.next  = load_seq_next,
+	.start = load2_seq_start,
+	.next  = load2_seq_next,
 	.show  = load_seq_show,
 	.stop  = smk_seq_stop,
 };
@@ -504,7 +604,8 @@ static ssize_t smk_write_load(struct file *file, const char __user *buf,
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
-	return smk_write_load_list(file, buf, count, ppos, NULL, NULL);
+	return smk_write_rules_list(file, buf, count, ppos, NULL, NULL,
+				    SMK_FIXED24_FMT);
 }
 
 static const struct file_operations smk_load_ops = {
@@ -574,6 +675,8 @@ static void smk_unlbl_ambient(char *oldambient)
 			printk(KERN_WARNING "%s:%d remove rc = %d\n",
 			       __func__, __LINE__, rc);
 	}
+	if (smack_net_ambient == NULL)
+		smack_net_ambient = smack_known_floor.smk_known;
 
 	rc = netlbl_cfg_unlbl_map_add(smack_net_ambient, PF_INET,
 				      NULL, NULL, &nai);
@@ -605,27 +708,28 @@ static int cipso_seq_show(struct seq_file *s, void *v)
 	struct list_head  *list = v;
 	struct smack_known *skp =
 		 list_entry(list, struct smack_known, list);
-	struct smack_cipso *scp = skp->smk_cipso;
-	char *cbp;
+	struct netlbl_lsm_secattr_catmap *cmp = skp->smk_netlabel.attr.mls.cat;
 	char sep = '/';
-	int cat = 1;
 	int i;
-	unsigned char m;
 
-	if (scp == NULL)
+	/*
+	 * Don't show a label that could not have been set using
+	 * /smack/cipso. This is in support of the notion that
+	 * anything read from /smack/cipso ought to be writeable
+	 * to /smack/cipso.
+	 *
+	 * /smack/cipso2 should be used instead.
+	 */
+	if (strlen(skp->smk_known) >= SMK_LABELLEN)
 		return 0;
 
-	seq_printf(s, "%s %3d", (char *)&skp->smk_known, scp->smk_level);
+	seq_printf(s, "%s %3d", skp->smk_known, skp->smk_netlabel.attr.mls.lvl);
 
-	cbp = scp->smk_catset;
-	for (i = 0; i < SMK_LABELLEN; i++)
-		for (m = 0x80; m != 0; m >>= 1) {
-			if (m & cbp[i]) {
-				seq_printf(s, "%c%d", sep, cat);
-				sep = ',';
-			}
-			cat++;
-		}
+	for (i = netlbl_secattr_catmap_walk(cmp, 0); i >= 0;
+	     i = netlbl_secattr_catmap_walk(cmp, i + 1)) {
+		seq_printf(s, "%c%d", sep, i);
+		sep = ',';
+	}
 
 	seq_putc(s, '\n');
 
@@ -653,23 +757,24 @@ static int smk_open_cipso(struct inode *inode, struct file *file)
 }
 
 /**
- * smk_write_cipso - write() for /smack/cipso
+ * smk_set_cipso - do the work for write() for cipso and cipso2
  * @file: file pointer, not actually used
  * @buf: where to get the data from
  * @count: bytes sent
  * @ppos: where to start
+ * @format: /smack/cipso or /smack/cipso2
  *
  * Accepts only one cipso rule per write call.
  * Returns number of bytes written or error code, as appropriate
  */
-static ssize_t smk_write_cipso(struct file *file, const char __user *buf,
-			       size_t count, loff_t *ppos)
+static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos, int format)
 {
 	struct smack_known *skp;
-	struct smack_cipso *scp = NULL;
-	char mapcatset[SMK_LABELLEN];
+	struct netlbl_lsm_secattr ncats;
+	char mapcatset[SMK_CIPSOLEN];
 	int maplevel;
-	int cat;
+	unsigned int cat;
 	int catlen;
 	ssize_t rc = -EINVAL;
 	char *data = NULL;
@@ -686,7 +791,8 @@ static ssize_t smk_write_cipso(struct file *file, const char __user *buf,
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
-	if (count < SMK_CIPSOMIN || count > SMK_CIPSOMAX)
+	if (format == SMK_FIXED24_FMT &&
+	    (count < SMK_CIPSOMIN || count > SMK_CIPSOMAX))
 		return -EINVAL;
 
 	data = kzalloc(count + 1, GFP_KERNEL);
@@ -698,11 +804,6 @@ static ssize_t smk_write_cipso(struct file *file, const char __user *buf,
 		goto unlockedout;
 	}
 
-	/* labels cannot begin with a '-' */
-	if (data[0] == '-') {
-		rc = -EINVAL;
-		goto unlockedout;
-	}
 	data[count] = '\0';
 	rule = data;
 	/*
@@ -715,7 +816,11 @@ static ssize_t smk_write_cipso(struct file *file, const char __user *buf,
 	if (skp == NULL)
 		goto out;
 
-	rule += SMK_LABELLEN;
+	if (format == SMK_FIXED24_FMT)
+		rule += SMK_LABELLEN;
+	else
+		rule += strlen(skp->smk_known);
+
 	ret = sscanf(rule, "%d", &maplevel);
 	if (ret != 1 || maplevel > SMACK_CIPSO_MAXLEVEL)
 		goto out;
@@ -725,41 +830,29 @@ static ssize_t smk_write_cipso(struct file *file, const char __user *buf,
 	if (ret != 1 || catlen > SMACK_CIPSO_MAXCATNUM)
 		goto out;
 
-	if (count != (SMK_CIPSOMIN + catlen * SMK_DIGITLEN))
+	if (format == SMK_FIXED24_FMT &&
+	    count != (SMK_CIPSOMIN + catlen * SMK_DIGITLEN))
 		goto out;
 
 	memset(mapcatset, 0, sizeof(mapcatset));
 
 	for (i = 0; i < catlen; i++) {
 		rule += SMK_DIGITLEN;
-		ret = sscanf(rule, "%d", &cat);
+		ret = sscanf(rule, "%u", &cat);
 		if (ret != 1 || cat > SMACK_CIPSO_MAXCATVAL)
 			goto out;
 
 		smack_catset_bit(cat, mapcatset);
 	}
 
-	if (skp->smk_cipso == NULL) {
-		scp = kzalloc(sizeof(struct smack_cipso), GFP_KERNEL);
-		if (scp == NULL) {
-			rc = -ENOMEM;
-			goto out;
-		}
+	rc = smk_netlbl_mls(maplevel, mapcatset, &ncats, SMK_CIPSOLEN);
+	if (rc >= 0) {
+		netlbl_secattr_catmap_free(skp->smk_netlabel.attr.mls.cat);
+		skp->smk_netlabel.attr.mls.cat = ncats.attr.mls.cat;
+		skp->smk_netlabel.attr.mls.lvl = ncats.attr.mls.lvl;
+		rc = count;
 	}
 
-	spin_lock_bh(&skp->smk_cipsolock);
-
-	if (scp == NULL)
-		scp = skp->smk_cipso;
-	else
-		skp->smk_cipso = scp;
-
-	scp->smk_level = maplevel;
-	memcpy(scp->smk_catset, mapcatset, sizeof(mapcatset));
-
-	spin_unlock_bh(&skp->smk_cipsolock);
-
-	rc = count;
 out:
 	mutex_unlock(&smack_cipso_lock);
 unlockedout:
@@ -767,6 +860,22 @@ unlockedout:
 	return rc;
 }
 
+/**
+ * smk_write_cipso - write() for /smack/cipso
+ * @file: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Accepts only one cipso rule per write call.
+ * Returns number of bytes written or error code, as appropriate
+ */
+static ssize_t smk_write_cipso(struct file *file, const char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	return smk_set_cipso(file, buf, count, ppos, SMK_FIXED24_FMT);
+}
+
 static const struct file_operations smk_cipso_ops = {
 	.open           = smk_open_cipso,
 	.read		= seq_read,
@@ -776,6 +885,80 @@ static const struct file_operations smk_cipso_ops = {
 };
 
 /*
+ * Seq_file read operations for /smack/cipso2
+ */
+
+/*
+ * Print cipso labels in format:
+ * label level[/cat[,cat]]
+ */
+static int cipso2_seq_show(struct seq_file *s, void *v)
+{
+	struct list_head  *list = v;
+	struct smack_known *skp =
+		 list_entry(list, struct smack_known, list);
+	struct netlbl_lsm_secattr_catmap *cmp = skp->smk_netlabel.attr.mls.cat;
+	char sep = '/';
+	int i;
+
+	seq_printf(s, "%s %3d", skp->smk_known, skp->smk_netlabel.attr.mls.lvl);
+
+	for (i = netlbl_secattr_catmap_walk(cmp, 0); i >= 0;
+	     i = netlbl_secattr_catmap_walk(cmp, i + 1)) {
+		seq_printf(s, "%c%d", sep, i);
+		sep = ',';
+	}
+
+	seq_putc(s, '\n');
+
+	return 0;
+}
+
+static const struct seq_operations cipso2_seq_ops = {
+	.start = cipso_seq_start,
+	.next  = cipso_seq_next,
+	.show  = cipso2_seq_show,
+	.stop  = smk_seq_stop,
+};
+
+/**
+ * smk_open_cipso2 - open() for /smack/cipso2
+ * @inode: inode structure representing file
+ * @file: "cipso2" file pointer
+ *
+ * Connect our cipso_seq_* operations with /smack/cipso2
+ * file_operations
+ */
+static int smk_open_cipso2(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &cipso2_seq_ops);
+}
+
+/**
+ * smk_write_cipso2 - write() for /smack/cipso2
+ * @file: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Accepts only one cipso rule per write call.
+ * Returns number of bytes written or error code, as appropriate
+ */
+static ssize_t smk_write_cipso2(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	return smk_set_cipso(file, buf, count, ppos, SMK_LONG_FMT);
+}
+
+static const struct file_operations smk_cipso2_ops = {
+	.open           = smk_open_cipso2,
+	.read		= seq_read,
+	.llseek         = seq_lseek,
+	.write		= smk_write_cipso2,
+	.release        = seq_release,
+};
+
+/*
  * Seq_file read operations for /smack/netlabel
  */
 
@@ -887,9 +1070,9 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 {
 	struct smk_netlbladdr *skp;
 	struct sockaddr_in newname;
-	char smack[SMK_LABELLEN];
+	char *smack;
 	char *sp;
-	char data[SMK_NETLBLADDRMAX + 1];
+	char *data;
 	char *host = (char *)&newname.sin_addr.s_addr;
 	int rc;
 	struct netlbl_audit audit_info;
@@ -911,10 +1094,23 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 		return -EPERM;
 	if (*ppos != 0)
 		return -EINVAL;
-	if (count < SMK_NETLBLADDRMIN || count > SMK_NETLBLADDRMAX)
+	if (count < SMK_NETLBLADDRMIN)
 		return -EINVAL;
-	if (copy_from_user(data, buf, count) != 0)
-		return -EFAULT;
+
+	data = kzalloc(count + 1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, count) != 0) {
+		rc = -EFAULT;
+		goto free_data_out;
+	}
+
+	smack = kzalloc(count + 1, GFP_KERNEL);
+	if (smack == NULL) {
+		rc = -ENOMEM;
+		goto free_data_out;
+	}
 
 	data[count] = '\0';
 
@@ -923,24 +1119,34 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	if (rc != 6) {
 		rc = sscanf(data, "%hhd.%hhd.%hhd.%hhd %s",
 			&host[0], &host[1], &host[2], &host[3], smack);
-		if (rc != 5)
-			return -EINVAL;
+		if (rc != 5) {
+			rc = -EINVAL;
+			goto free_out;
+		}
 		m = BEBITS;
 	}
-	if (m > BEBITS)
-		return -EINVAL;
+	if (m > BEBITS) {
+		rc = -EINVAL;
+		goto free_out;
+	}
 
-	/* if smack begins with '-', its an option, don't import it */
+	/*
+	 * If smack begins with '-', it is an option, don't import it
+	 */
 	if (smack[0] != '-') {
 		sp = smk_import(smack, 0);
-		if (sp == NULL)
-			return -EINVAL;
+		if (sp == NULL) {
+			rc = -EINVAL;
+			goto free_out;
+		}
 	} else {
 		/* check known options */
 		if (strcmp(smack, smack_cipso_option) == 0)
 			sp = (char *)smack_cipso_option;
-		else
-			return -EINVAL;
+		else {
+			rc = -EINVAL;
+			goto free_out;
+		}
 	}
 
 	for (temp_mask = 0; m > 0; m--) {
@@ -1006,6 +1212,11 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 
 	mutex_unlock(&smk_netlbladdr_lock);
 
+free_out:
+	kfree(smack);
+free_data_out:
+	kfree(data);
+
 	return rc;
 }
 
@@ -1119,6 +1330,7 @@ static ssize_t smk_read_direct(struct file *filp, char __user *buf,
 static ssize_t smk_write_direct(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
+	struct smack_known *skp;
 	char temp[80];
 	int i;
 
@@ -1136,7 +1348,20 @@ static ssize_t smk_write_direct(struct file *file, const char __user *buf,
 	if (sscanf(temp, "%d", &i) != 1)
 		return -EINVAL;
 
-	smack_cipso_direct = i;
+	/*
+	 * Don't do anything if the value hasn't actually changed.
+	 * If it is changing reset the level on entries that were
+	 * set up to be direct when they were created.
+	 */
+	if (smack_cipso_direct != i) {
+		mutex_lock(&smack_known_lock);
+		list_for_each_entry_rcu(skp, &smack_known_list, list)
+			if (skp->smk_netlabel.attr.mls.lvl ==
+			    smack_cipso_direct)
+				skp->smk_netlabel.attr.mls.lvl = i;
+		smack_cipso_direct = i;
+		mutex_unlock(&smack_known_lock);
+	}
 
 	return count;
 }
@@ -1148,6 +1373,84 @@ static const struct file_operations smk_direct_ops = {
 };
 
 /**
+ * smk_read_mapped - read() for /smack/mapped
+ * @filp: file pointer, not actually used
+ * @buf: where to put the result
+ * @count: maximum to send along
+ * @ppos: where to start
+ *
+ * Returns number of bytes read or error code, as appropriate
+ */
+static ssize_t smk_read_mapped(struct file *filp, char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	char temp[80];
+	ssize_t rc;
+
+	if (*ppos != 0)
+		return 0;
+
+	sprintf(temp, "%d", smack_cipso_mapped);
+	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
+
+	return rc;
+}
+
+/**
+ * smk_write_mapped - write() for /smack/mapped
+ * @file: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start
+ *
+ * Returns number of bytes written or error code, as appropriate
+ */
+static ssize_t smk_write_mapped(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct smack_known *skp;
+	char temp[80];
+	int i;
+
+	if (!capable(CAP_MAC_ADMIN))
+		return -EPERM;
+
+	if (count >= sizeof(temp) || count == 0)
+		return -EINVAL;
+
+	if (copy_from_user(temp, buf, count) != 0)
+		return -EFAULT;
+
+	temp[count] = '\0';
+
+	if (sscanf(temp, "%d", &i) != 1)
+		return -EINVAL;
+
+	/*
+	 * Don't do anything if the value hasn't actually changed.
+	 * If it is changing reset the level on entries that were
+	 * set up to be mapped when they were created.
+	 */
+	if (smack_cipso_mapped != i) {
+		mutex_lock(&smack_known_lock);
+		list_for_each_entry_rcu(skp, &smack_known_list, list)
+			if (skp->smk_netlabel.attr.mls.lvl ==
+			    smack_cipso_mapped)
+				skp->smk_netlabel.attr.mls.lvl = i;
+		smack_cipso_mapped = i;
+		mutex_unlock(&smack_known_lock);
+	}
+
+	return count;
+}
+
+static const struct file_operations smk_mapped_ops = {
+	.read		= smk_read_mapped,
+	.write		= smk_write_mapped,
+	.llseek		= default_llseek,
+};
+
+/**
  * smk_read_ambient - read() for /smack/ambient
  * @filp: file pointer, not actually used
  * @buf: where to put the result
@@ -1195,22 +1498,28 @@ static ssize_t smk_read_ambient(struct file *filp, char __user *buf,
 static ssize_t smk_write_ambient(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
-	char in[SMK_LABELLEN];
 	char *oldambient;
-	char *smack;
+	char *smack = NULL;
+	char *data;
+	int rc = count;
 
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
 
-	if (count >= SMK_LABELLEN)
-		return -EINVAL;
+	data = kzalloc(count + 1, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
 
-	if (copy_from_user(in, buf, count) != 0)
-		return -EFAULT;
+	if (copy_from_user(data, buf, count) != 0) {
+		rc = -EFAULT;
+		goto out;
+	}
 
-	smack = smk_import(in, count);
-	if (smack == NULL)
-		return -EINVAL;
+	smack = smk_import(data, count);
+	if (smack == NULL) {
+		rc = -EINVAL;
+		goto out;
+	}
 
 	mutex_lock(&smack_ambient_lock);
 
@@ -1220,7 +1529,9 @@ static ssize_t smk_write_ambient(struct file *file, const char __user *buf,
 
 	mutex_unlock(&smack_ambient_lock);
 
-	return count;
+out:
+	kfree(data);
+	return rc;
 }
 
 static const struct file_operations smk_ambient_ops = {
@@ -1271,8 +1582,9 @@ static ssize_t smk_read_onlycap(struct file *filp, char __user *buf,
 static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
-	char in[SMK_LABELLEN];
+	char *data;
 	char *sp = smk_of_task(current->cred->security);
+	int rc = count;
 
 	if (!capable(CAP_MAC_ADMIN))
 		return -EPERM;
@@ -1285,11 +1597,9 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 	if (smack_onlycap != NULL && smack_onlycap != sp)
 		return -EPERM;
 
-	if (count >= SMK_LABELLEN)
-		return -EINVAL;
-
-	if (copy_from_user(in, buf, count) != 0)
-		return -EFAULT;
+	data = kzalloc(count, GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
 
 	/*
 	 * Should the null string be passed in unset the onlycap value.
@@ -1297,10 +1607,17 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 	 * smk_import only expects to return NULL for errors. It
 	 * is usually the case that a nullstring or "\n" would be
 	 * bad to pass to smk_import but in fact this is useful here.
+	 *
+	 * smk_import will also reject a label beginning with '-',
+	 * so "-usecapabilities" will also work.
 	 */
-	smack_onlycap = smk_import(in, count);
+	if (copy_from_user(data, buf, count) != 0)
+		rc = -EFAULT;
+	else
+		smack_onlycap = smk_import(data, count);
 
-	return count;
+	kfree(data);
+	return rc;
 }
 
 static const struct file_operations smk_onlycap_ops = {
@@ -1398,25 +1715,7 @@ static int load_self_seq_show(struct seq_file *s, void *v)
 	struct smack_rule *srp =
 		 list_entry(list, struct smack_rule, list);
 
-	seq_printf(s, "%s %s", (char *)srp->smk_subject,
-		   (char *)srp->smk_object);
-
-	seq_putc(s, ' ');
-
-	if (srp->smk_access & MAY_READ)
-		seq_putc(s, 'r');
-	if (srp->smk_access & MAY_WRITE)
-		seq_putc(s, 'w');
-	if (srp->smk_access & MAY_EXEC)
-		seq_putc(s, 'x');
-	if (srp->smk_access & MAY_APPEND)
-		seq_putc(s, 'a');
-	if (srp->smk_access & MAY_TRANSMUTE)
-		seq_putc(s, 't');
-	if (srp->smk_access == 0)
-		seq_putc(s, '-');
-
-	seq_putc(s, '\n');
+	smk_rule_show(s, srp, SMK_LABELLEN);
 
 	return 0;
 }
@@ -1430,7 +1729,7 @@ static const struct seq_operations load_self_seq_ops = {
 
 
 /**
- * smk_open_load_self - open() for /smack/load-self
+ * smk_open_load_self - open() for /smack/load-self2
  * @inode: inode structure representing file
  * @file: "load" file pointer
  *
@@ -1454,8 +1753,8 @@ static ssize_t smk_write_load_self(struct file *file, const char __user *buf,
 {
 	struct task_smack *tsp = current_security();
 
-	return smk_write_load_list(file, buf, count, ppos, &tsp->smk_rules,
-					&tsp->smk_rules_lock);
+	return smk_write_rules_list(file, buf, count, ppos, &tsp->smk_rules,
+				    &tsp->smk_rules_lock, SMK_FIXED24_FMT);
 }
 
 static const struct file_operations smk_load_self_ops = {
@@ -1467,24 +1766,42 @@ static const struct file_operations smk_load_self_ops = {
 };
 
 /**
- * smk_write_access - handle access check transaction
+ * smk_user_access - handle access check transaction
  * @file: file pointer
  * @buf: data from user space
  * @count: bytes sent
  * @ppos: where to start - must be 0
  */
-static ssize_t smk_write_access(struct file *file, const char __user *buf,
-				size_t count, loff_t *ppos)
+static ssize_t smk_user_access(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos, int format)
 {
 	struct smack_rule rule;
 	char *data;
+	char *cod;
 	int res;
 
 	data = simple_transaction_get(file, buf, count);
 	if (IS_ERR(data))
 		return PTR_ERR(data);
 
-	if (count < SMK_LOADLEN || smk_parse_rule(data, &rule, 0))
+	if (format == SMK_FIXED24_FMT) {
+		if (count < SMK_LOADLEN)
+			return -EINVAL;
+		res = smk_parse_rule(data, &rule, 0);
+	} else {
+		/*
+		 * Copy the data to make sure the string is terminated.
+		 */
+		cod = kzalloc(count + 1, GFP_KERNEL);
+		if (cod == NULL)
+			return -ENOMEM;
+		memcpy(cod, data, count);
+		cod[count] = '\0';
+		res = smk_parse_long_rule(cod, &rule, 0);
+		kfree(cod);
+	}
+
+	if (res)
 		return -EINVAL;
 
 	res = smk_access(rule.smk_subject, rule.smk_object, rule.smk_access,
@@ -1493,7 +1810,23 @@ static ssize_t smk_write_access(struct file *file, const char __user *buf,
 	data[1] = '\0';
 
 	simple_transaction_set(file, 2);
-	return SMK_LOADLEN;
+
+	if (format == SMK_FIXED24_FMT)
+		return SMK_LOADLEN;
+	return count;
+}
+
+/**
+ * smk_write_access - handle access check transaction
+ * @file: file pointer
+ * @buf: data from user space
+ * @count: bytes sent
+ * @ppos: where to start - must be 0
+ */
+static ssize_t smk_write_access(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	return smk_user_access(file, buf, count, ppos, SMK_FIXED24_FMT);
 }
 
 static const struct file_operations smk_access_ops = {
@@ -1503,6 +1836,163 @@ static const struct file_operations smk_access_ops = {
 	.llseek		= generic_file_llseek,
 };
 
+
+/*
+ * Seq_file read operations for /smack/load2
+ */
+
+static int load2_seq_show(struct seq_file *s, void *v)
+{
+	struct list_head *list = v;
+	struct smack_master_list *smlp =
+		 list_entry(list, struct smack_master_list, list);
+
+	smk_rule_show(s, smlp->smk_rule, SMK_LONGLABEL);
+
+	return 0;
+}
+
+static const struct seq_operations load2_seq_ops = {
+	.start = load2_seq_start,
+	.next  = load2_seq_next,
+	.show  = load2_seq_show,
+	.stop  = smk_seq_stop,
+};
+
+/**
+ * smk_open_load2 - open() for /smack/load2
+ * @inode: inode structure representing file
+ * @file: "load2" file pointer
+ *
+ * For reading, use load2_seq_* seq_file reading operations.
+ */
+static int smk_open_load2(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &load2_seq_ops);
+}
+
+/**
+ * smk_write_load2 - write() for /smack/load2
+ * @file: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start - must be 0
+ *
+ */
+static ssize_t smk_write_load2(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	/*
+	 * Must have privilege.
+	 */
+	if (!capable(CAP_MAC_ADMIN))
+		return -EPERM;
+
+	return smk_write_rules_list(file, buf, count, ppos, NULL, NULL,
+				    SMK_LONG_FMT);
+}
+
+static const struct file_operations smk_load2_ops = {
+	.open           = smk_open_load2,
+	.read		= seq_read,
+	.llseek         = seq_lseek,
+	.write		= smk_write_load2,
+	.release        = seq_release,
+};
+
+/*
+ * Seq_file read operations for /smack/load-self2
+ */
+
+static void *load_self2_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct task_smack *tsp = current_security();
+
+	return smk_seq_start(s, pos, &tsp->smk_rules);
+}
+
+static void *load_self2_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct task_smack *tsp = current_security();
+
+	return smk_seq_next(s, v, pos, &tsp->smk_rules);
+}
+
+static int load_self2_seq_show(struct seq_file *s, void *v)
+{
+	struct list_head *list = v;
+	struct smack_rule *srp =
+		 list_entry(list, struct smack_rule, list);
+
+	smk_rule_show(s, srp, SMK_LONGLABEL);
+
+	return 0;
+}
+
+static const struct seq_operations load_self2_seq_ops = {
+	.start = load_self2_seq_start,
+	.next  = load_self2_seq_next,
+	.show  = load_self2_seq_show,
+	.stop  = smk_seq_stop,
+};
+
+/**
+ * smk_open_load_self2 - open() for /smack/load-self2
+ * @inode: inode structure representing file
+ * @file: "load" file pointer
+ *
+ * For reading, use load_seq_* seq_file reading operations.
+ */
+static int smk_open_load_self2(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &load_self2_seq_ops);
+}
+
+/**
+ * smk_write_load_self2 - write() for /smack/load-self2
+ * @file: file pointer, not actually used
+ * @buf: where to get the data from
+ * @count: bytes sent
+ * @ppos: where to start - must be 0
+ *
+ */
+static ssize_t smk_write_load_self2(struct file *file, const char __user *buf,
+			      size_t count, loff_t *ppos)
+{
+	struct task_smack *tsp = current_security();
+
+	return smk_write_rules_list(file, buf, count, ppos, &tsp->smk_rules,
+				    &tsp->smk_rules_lock, SMK_LONG_FMT);
+}
+
+static const struct file_operations smk_load_self2_ops = {
+	.open           = smk_open_load_self2,
+	.read		= seq_read,
+	.llseek         = seq_lseek,
+	.write		= smk_write_load_self2,
+	.release        = seq_release,
+};
+
+/**
+ * smk_write_access2 - handle access check transaction
+ * @file: file pointer
+ * @buf: data from user space
+ * @count: bytes sent
+ * @ppos: where to start - must be 0
+ */
+static ssize_t smk_write_access2(struct file *file, const char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	return smk_user_access(file, buf, count, ppos, SMK_LONG_FMT);
+}
+
+static const struct file_operations smk_access2_ops = {
+	.write		= smk_write_access2,
+	.read		= simple_transaction_read,
+	.release	= simple_transaction_release,
+	.llseek		= generic_file_llseek,
+};
+
 /**
  * smk_fill_super - fill the /smackfs superblock
  * @sb: the empty superblock
@@ -1539,6 +2029,16 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
 			"load-self", &smk_load_self_ops, S_IRUGO|S_IWUGO},
 		[SMK_ACCESSES] = {
 			"access", &smk_access_ops, S_IRUGO|S_IWUGO},
+		[SMK_MAPPED] = {
+			"mapped", &smk_mapped_ops, S_IRUGO|S_IWUSR},
+		[SMK_LOAD2] = {
+			"load2", &smk_load2_ops, S_IRUGO|S_IWUSR},
+		[SMK_LOAD_SELF2] = {
+			"load-self2", &smk_load_self2_ops, S_IRUGO|S_IWUGO},
+		[SMK_ACCESS2] = {
+			"access2", &smk_access2_ops, S_IRUGO|S_IWUGO},
+		[SMK_CIPSO2] = {
+			"cipso2", &smk_cipso2_ops, S_IRUGO|S_IWUSR},
 		/* last one */
 			{""}
 	};
@@ -1581,6 +2081,15 @@ static struct file_system_type smk_fs_type = {
 
 static struct vfsmount *smackfs_mount;
 
+static int __init smk_preset_netlabel(struct smack_known *skp)
+{
+	skp->smk_netlabel.domain = skp->smk_known;
+	skp->smk_netlabel.flags =
+		NETLBL_SECATTR_DOMAIN | NETLBL_SECATTR_MLS_LVL;
+	return smk_netlbl_mls(smack_cipso_direct, skp->smk_known,
+				&skp->smk_netlabel, strlen(skp->smk_known));
+}
+
 /**
  * init_smk_fs - get the smackfs superblock
  *
@@ -1597,6 +2106,7 @@ static struct vfsmount *smackfs_mount;
 static int __init init_smk_fs(void)
 {
 	int err;
+	int rc;
 
 	if (!security_module_enable(&smack_ops))
 		return 0;
@@ -1628,6 +2138,25 @@ static int __init init_smk_fs(void)
 	INIT_LIST_HEAD(&smack_known_star.smk_rules);
 	INIT_LIST_HEAD(&smack_known_web.smk_rules);
 
+	rc = smk_preset_netlabel(&smack_known_floor);
+	if (err == 0 && rc < 0)
+		err = rc;
+	rc = smk_preset_netlabel(&smack_known_hat);
+	if (err == 0 && rc < 0)
+		err = rc;
+	rc = smk_preset_netlabel(&smack_known_huh);
+	if (err == 0 && rc < 0)
+		err = rc;
+	rc = smk_preset_netlabel(&smack_known_invalid);
+	if (err == 0 && rc < 0)
+		err = rc;
+	rc = smk_preset_netlabel(&smack_known_star);
+	if (err == 0 && rc < 0)
+		err = rc;
+	rc = smk_preset_netlabel(&smack_known_web);
+	if (err == 0 && rc < 0)
+		err = rc;
+
 	return err;
 }
 



