Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab2CZQ7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:59:22 -0400
Received: from nm23.access.bullet.mail.mud.yahoo.com ([66.94.237.88]:24572
	"HELO nm23.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932724Ab2CZQ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:59:21 -0400
X-Yahoo-Newman-Id: 609319.38052.bm@smtp104.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8POGH.8VM1kVaT5XcOMtY6zZtFVZomwW_qM4I93U_Zlu9sf
 XSoXX6O19MFVWzXur0RxE0xYPkBLZy584Jmlvm6DmH7scSmSO2DVR177Fl0t
 LiGLWRDrg__c1XBlzfPAtZLn3stEAHSabrSAKqkhO8K.mflwy8TzEMWWgcF.
 QwzMYcvGN7mEdS6wPiuXnBQpOl4daPYWo6GI_rE80Ka.mh.2lNiuOV0znQL8
 EGRQdN5vIOf.T7Ous4R0AeSWCY6MsmEQ0cIb.2V1VdedhoA9PeaVFJEmORUY
 DaKjT20LgqoIieOIqTHWCuzd9mCPMmf8yowoC2VddcloBcuk.puFcbjsuwhm
 JkUpoeSLPwHO1MWC30CpnW_TzDNF8Q.seZytVVY2NSJ.hWx1rtV.L3kTt_uG
 3UjJ0FyeKVwS3mf52jGY4v_dQOpf8EQhhTUDeLPO5e2XYqk_lkDeoAkIRJNt
 I
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4F70A067.9070907@schaufler-ca.com>
Date: Mon, 26 Mar 2012 09:59:19 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] audit: always report seccomp violations
References: <20120323233212.GA18484@www.outflux.net> <4F6F6839.6020605@schaufler-ca.com> <CAGXu5jJB8nD1LJSJSDx2CF_j_-uLKOmq++2OHBVvXhvao37EeQ@mail.gmail.com>
In-Reply-To: <CAGXu5jJB8nD1LJSJSDx2CF_j_-uLKOmq++2OHBVvXhvao37EeQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/2012 8:56 AM, Kees Cook wrote:
> On Sun, Mar 25, 2012 at 11:47 AM, Casey Schaufler
> <casey@schaufler-ca.com> wrote:
>> On 3/23/2012 4:32 PM, Kees Cook wrote:
>>> When a program violates its own seccomp rules, that is a pretty dire
>>> situation, and the audit message should always be reported (not just
>>> when there is already a rule active for the process).
>> Hmm. If the program is never going to violate its own
>> seccomp rules it seems sort of silly to have them in the
>> first place, doesn't it? Oh, I know that the expectation
>> of seccomp is that the application would only try something
>> you've disallowed if it gets compromised. Problem is that
> Well, either compromised or doing something new (e.g. a library in the
> code has changed).
>
>> Modern Programmers tend to rely very heavily on the opaque
>> behavior of APIs that they don't understand nor particularly
>> care if they understand. When assumptions are made about the
>> behavior of the API code, and the API code changes, as
>> occurs with amazing frequency on today's mobile devices,
>> there are going to be surprises. I would wager that the
>> modern frequency of API changes will result in this behavior
>> being very unpopular.
> You seem to be advocating for my patch -- instead of the program
> "silently" getting killed, now there will be notification. A seccomp
> failure is extremely uncommon; much less common that core dumps. This
> is why it should always be reported -- it is uncommon and important to
> notice.

Silence is golden. The situation that I am concerned with is one where
a library changes and a program preforms an action that results in a
violation. The application runtime environment notices the applications
demise and restarts it, resulting in a repeat of the violation.

In a classic computer environment you would want the log filled with
notifications so that the user could do something about it. On a
phone, settop box, TV set or seatback entertainment system logging is
evil. No one who has any business seeing a log message has any desire
to see one. It does not matter how important the log message might be.

It's getting harder and harder to have rational error handling at the
OS level as application environments move to higher levels and greater
abstraction. Because seccomp is an OS interface level facility there
are going to be many cases where it fails to align with the intent of
its highly abstracted users. When it does, the programmers are not
going to look at the OS level logs, they are going to look at the API
definitions and such.

In the end I am opposed to any logging that can't be turned off. There
is enough difference in environments and expectations that you can't
say that something should always be reported. I am not saying that I
approve of this situation, but it is clear that most modern application
developers want to hear as little from the OS as possible. Even in
cases where they should be paying attention.

>>> This change makes the audit_seccomp() logic similar to audit_core_dumps()
>>> (it does not require an active context). Since core dumps are more
>>> common, they sit behind an "audit_enabled" test. Audit reports of seccomp
>>> failures should always be visible, and fall back to printk when auditd
>>> is not running.
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>>  include/linux/audit.h |    8 +-------
>>>  kernel/auditsc.c      |   11 +++++++++--
>>>  2 files changed, 10 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/include/linux/audit.h b/include/linux/audit.h
>>> index ed3ef19..596077f 100644
>>> --- a/include/linux/audit.h
>>> +++ b/include/linux/audit.h
>>> @@ -463,7 +463,7 @@ extern void audit_putname(const char *name);
>>>  extern void __audit_inode(const char *name, const struct dentry *dentry);
>>>  extern void __audit_inode_child(const struct dentry *dentry,
>>>                               const struct inode *parent);
>>> -extern void __audit_seccomp(unsigned long syscall);
>>> +extern void audit_seccomp(unsigned long syscall);
>>>  extern void __audit_ptrace(struct task_struct *t);
>>>
>>>  static inline int audit_dummy_context(void)
>>> @@ -508,12 +508,6 @@ static inline void audit_inode_child(const struct dentry *dentry,
>>>  }
>>>  void audit_core_dumps(long signr);
>>>
>>> -static inline void audit_seccomp(unsigned long syscall)
>>> -{
>>> -     if (unlikely(!audit_dummy_context()))
>>> -             __audit_seccomp(syscall);
>>> -}
>>> -
>>>  static inline void audit_ptrace(struct task_struct *t)
>>>  {
>>>       if (unlikely(!audit_dummy_context()))
>>> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
>>> index af1de0f..a5caecd 100644
>>> --- a/kernel/auditsc.c
>>> +++ b/kernel/auditsc.c
>>> @@ -2693,7 +2693,7 @@ static void audit_log_abend(struct audit_buffer *ab, char *reason, long signr)
>>>   * @signr: signal value
>>>   *
>>>   * If a process ends with a core dump, something fishy is going on and we
>>> - * should record the event for investigation.
>>> + * should record the event for investigation, if auditing is enabled.
>>>   */
>>>  void audit_core_dumps(long signr)
>>>  {
>>> @@ -2710,7 +2710,14 @@ void audit_core_dumps(long signr)
>>>       audit_log_end(ab);
>>>  }
>>>
>>> -void __audit_seccomp(unsigned long syscall)
>>> +/**
>>> + * audit_seccomp - record information about processes that violate seccomp
>>> + * @syscall: syscall number that triggered the seccomp violation
>>> + *
>>> + * If a process violates its own seccomp rules, something has gone very
>>> + * wrong, and this event should always be reported for investigation.
>>> + */
>>> +void audit_seccomp(unsigned long syscall)
>>>  {
>>>       struct audit_buffer *ab;
>>>
>
>

