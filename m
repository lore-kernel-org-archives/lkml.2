Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab1EYOoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:44:07 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52877 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab1EYOoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:44:04 -0400
Date: Wed, 25 May 2011 09:44:00 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>
Cc: Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
        security@kernel.org, kees@ubuntu.com,
        Tavis Ormandy <taviso@cmpxchg8b.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [Security] Fwd: Oops (bad memory deref) in slab_alloc() due to
 filp_cachep holding incorrect values
Message-ID: <20110525144400.GA26206@mail.hallyn.com>
References: <BANLkTikfqV57AtCckh99jAT2O38mM6MzTA@mail.gmail.com>
 <BANLkTikey3L4doiHY=__=690TZNsXqRHUQ@mail.gmail.com>
 <alpine.DEB.2.00.1105231133580.29047@router.home>
 <BANLkTi=-xRRxi4CtxMLt0VgTJWSdiVQugw@mail.gmail.com>
 <BANLkTin1zhuA3z61cBWwJws+P1-xA5bGZA@mail.gmail.com>
 <BANLkTikp4VweUE+JrkXRSJ-8kEEcPKpw8g@mail.gmail.com>
 <BANLkTimB6pQyux4XEqqEUvuPGsZ2Bw0L8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimB6pQyux4XEqqEUvuPGsZ2Bw0L8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Robert Święcki (robert@swiecki.net):
> On Wed, May 25, 2011 at 10:28 AM, Eugene Teo <eugeneteo@kernel.sg> wrote:
> > Cc'ed David as well.
> >
> > On Tue, May 24, 2011 at 8:52 PM, Robert Święcki <robert@swiecki.net> wrote:
> >> And the repro - I think this might be exploitable (user-space NULL ptr
> >> deref at the first glance, in cap_capable() while in sys_setgid()).
> >> Works for me with 2.6.39 and the following config:
> >> http://alt.swiecki.net/linux_kernel/ise-test-2.6.39-kernel-config.txt
> >>
> >> It works for me with apparmor loaded, but looking at the code it
> >> should work with SELinux as well (both call cap_capable()). Could be
> >> some regression of http://securitytracker.com/id?1024384
> >>
> >> It works with 2.6.39 but not with 2.6.39-rc4. Found with Tavis
> >> Ormandy's http://code.google.com/p/iknowthis/
> 
> Given that it doesn't seem to appear in 2.6.39-rc4, and judging by the
> names of functions involved, this change looks suspiciously related to
> this oops (even if it just made the keyctl problem visible)
> http://git.itanic.dy.fi/?p=linux-stable;a=commitdiff;h=47a150edc2ae734c0f4bf50aa19499e23b9a46f8
> 
> >> #include <sys/stat.h>
> >> #include <sys/wait.h>
> >> #include <unistd.h>
> >> #include <sys/syscall.h>
> >> #include <linux/keyctl.h>
> >> #include <linux/sched.h>
> >>
> >> int TH1(void *dummy) {
> >>        syscall(__NR_keyctl, KEYCTL_SESSION_TO_PARENT);

Thanks!

Fooi, it looks like all users of cred_alloc_blank() may need to be
audited wrt commit 47a150edc2ae734c0f4bf50aa19499e23b9a46f8.

Does this fix the bug you're seeing?

From: Serge E. Hallyn <serge.hallyn@canonical.com>
Date: Wed, 25 May 2011 15:41:23 +0100
Subject: [PATCH 1/1] Set cred->user_ns in key_replace_session_keyring

Since this cred was not created with copy_creds(), it needs to get
initialized.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
---
 security/keys/process_keys.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 6c0480d..92a3a5d 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -847,6 +847,7 @@ void key_replace_session_keyring(void)
 	new-> sgid	= old-> sgid;
 	new->fsgid	= old->fsgid;
 	new->user	= get_uid(old->user);
+	new->user_ns	= new->user->user_ns;
 	new->group_info	= get_group_info(old->group_info);
 
 	new->securebits	= old->securebits;
-- 
1.7.0.4

