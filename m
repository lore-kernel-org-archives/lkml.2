Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2K0S0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:26:37 -0500
Received: from smtp109.biz.mail.ne1.yahoo.com ([98.138.206.46]:47750 "HELO
	smtp109.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932119Ab2K0S0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:26:35 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qMRwcVUVM1m_BfxzZiC8LbfG.01D0PTPj_ddJiE4ymUFI95
 qC1mvataYHpqURx2CCwrq_pvtm_li59nkM6TZy8uRRKUeu3MfpNX9FYhCd6t
 RuVJQTV5D3tCvykaY73E8zATbysSebER2QT.S9EloMXVbQNMJri95.2nz7NK
 5aqEpIds4DGZky8cZxWrRY9PWPxjXae7pAb9PFR1yc6faOBgCuyH3A9DYFoK
 q9bA6xUAfPXJLlEgdzog258nHLzH8xBs41QzkT824VPnWHbdS_gu9LHsbPLy
 TgJ1Iua7ZfRDkk.LCNn0kQbvPXs.qeYmMbqHlQWFDC5x9YOSvN7xKs2fe6xI
 rZhgPYCPfGBcJfclgoQZh3GgJYan.e5EwzRJjDmpOCRcwQJhaOPvDZi.ZgFU
 gLiP0tEhnmtEKNaNjFuwEEDrYj92OI30y0qFCT5RHSgKApF.uhUXmG.Cqvpm
 gD9fvT0BeY5V52Mvx7ZVZ23UM2v.Mguk2Bh_FClxH2SQyrG9wIoe1gmlTsto
 YVcRL13I01Vx0AN1uHBpmSwfosbQ.7d9VOOLCZg8YdgQWYZX3xAyvI4Y-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50B505E1.80307@schaufler-ca.com>
Date: Tue, 27 Nov 2012 10:26:41 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rafal Krypa <r.krypa@samsung.com>
CC: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 0/3] Smack: add support for modification of existing rules,
 restructure rules list showing in smackfs
References: <1354038021-28324-1-git-send-email-r.krypa@samsung.com>
In-Reply-To: <1354038021-28324-1-git-send-email-r.krypa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 9:40 AM, Rafal Krypa wrote:
> The following three patches are intended to introduce in-place
> modification of Smack rules. Until now Smack supported only
> overwriting of existing rules. To change permitted access for a given
> subject and object, user had to read list of rules to get current
> accesses, modify it and write modified rule back to kernel. This way
> was inefficient, non-atomic and unnecessarily difficult.
> New interface is intended to ease such modifications.
>
> I have prepared three patches:
> 1. Use RCU functions and read locking in smackfs seq list operations
>
> Because rule lists will now get modified by list_replace_rcu(), this
> one is intended to assure RCU reader critical sections in smackfs.

The whole change to RCU is predicated on the use of list_replace_rcu.
But there is no reason to use list_replace_rcu. The existing code assigns
an integer value into an existing list entry, and there is no reason
not to continue doing so. The patch results in code that is working
harder than it has to.

Don't create a new list entry and replace the old list entry.
Do modify the access field of the existing entry.
This patch is completely unnecessary.

> 2. Remove global master list of rules
>
> This is for avoiding having to modify rules in two places (per subject
> list and the global list). The master list was redundant and kept up
> for backward compatibility with previous smackfs seq operations code.

There is no need to modify the rule in two places. The master list
contains pointers to the same rule structures as the per-subject list.
This is another reason not to use list_replace_rcu. You can get rid
of the master list for the shear joy of it, but there isn't any need
to do so to complete the work at hand.

> 3. Add support for modification of existing rules
>
> The actual patch with new interface.
> A previous version of this one has posted previously
> (http://thread.gmane.org/gmane.linux.documentation/6759),
> but was proven to be wrong.

This can be made much simpler. It should duplicate the code for load2
with the exception of how the access is determined. Changes to reduce
code duplication are of course appropriate.

>
> Rafal Krypa (3):
>   Smack: use RCU functions and read locking in smackfs seq list
>     operations
>   Smack: remove global master list of rules
>   Smack: add support for modification of existing rules
>
>  Documentation/security/Smack.txt |   11 ++
>  security/smack/smackfs.c         |  362 ++++++++++++++++++++++++--------------
>  2 files changed, 239 insertions(+), 134 deletions(-)
>
