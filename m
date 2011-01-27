Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1A0S7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 13:59:47 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56223 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089Ab1A0S7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 13:59:45 -0500
X-Sasl-enc: nuPuVFTSoenbk5Rwf+Rd7o3i09A+vsfGZc5++N4ruWOd 1296154784
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
To: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH v3 6/6] eCryptfs: added support for the encrypted key type
Date: Thu, 27 Jan 2011 19:59:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-66.fc13.x86_64; KDE/4.5.5; x86_64; ; )
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmorris@namei.org, zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
        ramunno@polito.it, tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
References: <1295887497-20198-7-git-send-email-roberto.sassu@polito.it> <1295887497-20198-1-git-send-email-roberto.sassu@polito.it> <6901.1296041316@redhat.com>
In-Reply-To: <6901.1296041316@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101271959.39521.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David

thanks for the review!
I just need a clarification about the comment of this patch.
Regarding the locking issue, this also applies for the unpatched
version of eCryptfs, because the 'user' key type has the
'update' method defined. However, i think the read lock is not
enough because eCryptfs directly writes on the key's payload
in order to update the state of the authentication token.

I've developed a small patch, i will post shortly with Tyler Hicks
in CC, that locks requested keys for writing.

Roberto Sassu


On Wednesday, January 26, 2011 12:28:36 pm David Howells wrote:
> Roberto Sassu <roberto.sassu@polito.it> wrote:
> 
> >  	(*auth_tok_key) = request_key(&key_type_user, sig, NULL);
> >  	if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
> > -		printk(KERN_ERR "Could not find key with description: [%s]\n",
> > -		       sig);
> > -		rc = process_request_key_err(PTR_ERR(*auth_tok_key));
> > -		goto out;
> > +		(*auth_tok_key) = ecryptfs_get_encrypted_key(sig);
> > +		if (!(*auth_tok_key) || IS_ERR(*auth_tok_key)) {
> > +			printk(KERN_ERR "Could not find key with description: [%s]\n",
> > +			      sig);
> > +			rc = process_request_key_err(PTR_ERR(*auth_tok_key));
> > +			goto out;
> > +		}
> >  	}
> >  	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
> >  	if (ecryptfs_verify_version((*auth_tok)->version)) {
> 
> You need some locking here, even if it's only use of the RCU read lock.
> Encrypted-type keys have an update method and so may change under you.
> 
> David
> ---
> 
