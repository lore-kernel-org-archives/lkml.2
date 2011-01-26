Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1AZL24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:28:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab1AZL2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:28:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1295887497-20198-7-git-send-email-roberto.sassu@polito.it>
References: <1295887497-20198-7-git-send-email-roberto.sassu@polito.it> <1295887497-20198-1-git-send-email-roberto.sassu@polito.it>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com, ramunno@polito.it,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
Subject: Re: [RFC][PATCH v3 6/6] eCryptfs: added support for the encrypted key type
Date: Wed, 26 Jan 2011 11:28:36 +0000
Message-ID: <6901.1296041316@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roberto Sassu <roberto.sassu@polito.it> wrote:

>  	(*auth_tok_key) = request_key(&key_type_user, sig, NULL);
>  	if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
> -		printk(KERN_ERR "Could not find key with description: [%s]\n",
> -		       sig);
> -		rc = process_request_key_err(PTR_ERR(*auth_tok_key));
> -		goto out;
> +		(*auth_tok_key) = ecryptfs_get_encrypted_key(sig);
> +		if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
> +			printk(KERN_ERR "Could not find key with description: [%s]\n",
> +			      sig);
> +			rc = process_request_key_err(PTR_ERR(*auth_tok_key));
> +			goto out;
> +		}
>  	}
>  	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
>  	if (ecryptfs_verify_version((*auth_tok)->version)) {

You need some locking here, even if it's only use of the RCU read lock.
Encrypted-type keys have an update method and so may change under you.

David
---
