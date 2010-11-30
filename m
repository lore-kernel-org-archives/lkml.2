Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0K3KTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 05:19:15 -0500
Received: from adelie.canonical.com ([91.189.90.139]:58005 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab0K3KTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 05:19:13 -0500
Message-ID: <4CF4CF9C.30605@canonical.com>
Date: Tue, 30 Nov 2010 02:19:08 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: wzt.wzt@gmail.com
CC: linux-kernel@vger.kernel.org, apparmor@lists.ubuntu.com,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] APPARMOR: Fix NULL Pointer dereference while __add_new_profile
References: <20101126151847.GA2721@localhost.localdomain>
In-Reply-To: <20101126151847.GA2721@localhost.localdomain>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2010 07:18 AM, wzt.wzt@gmail.com wrote:
> In aa_replace_profiles(), if __lookup_parent() path failed, policy is set 
> to NULL and goto audit label, old_profile and rename_profile are both NULL,
> __add_new_profile is called, the parameter policy is NULL, it will cause
> NULL pointer dereference via __list_add_profile(&policy->profiles, profile);
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
> 
NAK, we can't just fail adding the profile to the policy here.  If this
was an error we would need to either return an error or handle it before
the this function was called.

In this case when __lookup_parent fails it sets error = -ENOENT before jumping
to audit:

The way the audit routines work is that they will return the error passed
into them with a few exceptions.  If in complain mode it can override,
the apparmor set eperm and eaccess error codes, and it can return errors that
occurred during auditing.

So in this case the error condition is guaranteed to be set and
__add_new_profile will never get called.

Currently this isn't very clear in the code and it could use a comment, or
maybe even some reworking so that the failure path calls audit_policy directly

> ---
>  security/apparmor/policy.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
> index 52cc865..832d9e9 100644
> --- a/security/apparmor/policy.c
> +++ b/security/apparmor/policy.c
> @@ -940,6 +940,8 @@ static int replacement_allowed(struct aa_profile *profile, int noreplace,
>  static void __add_new_profile(struct aa_namespace *ns, struct aa_policy *policy,
>  			      struct aa_profile *profile)
>  {
> +	if (!policy)
> +		return ;
>  	if (policy != &ns->base)
>  		/* released on profile replacement or free_profile */
>  		profile->parent = aa_get_profile((struct aa_profile *) policy);

