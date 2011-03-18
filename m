Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab1CRPrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:47:10 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36389 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756257Ab1CRPrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:47:05 -0400
X-Sasl-enc: 8J51c8xWK47B/mPA5vTuLbTKrUFvd6BHkGgRIlfpoKlM 1300463224
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] eCryptfs: move ecryptfs_find_auth_tok_for_sig() call before mutex_lock
Date: Fri, 18 Mar 2011 16:44:13 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.35.11-83.fc14.x86_64; KDE/4.5.5; x86_64; ; )
Cc: kirkland@canonical.com, dhowells@redhat.com, jmorris@namei.org,
        linux-fsdevel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
References: <1300362538-11502-1-git-send-email-roberto.sassu@polito.it> <1300362538-11502-5-git-send-email-roberto.sassu@polito.it> <20110318153049.GB22193@boyd.l.tihix.com>
In-Reply-To: <20110318153049.GB22193@boyd.l.tihix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103181644.13456.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 18, 2011 04:30:50 pm Tyler Hicks wrote:
> On Thu Mar 17, 2011 at 12:48:53PM +0100, Roberto Sassu <roberto.sassu@polito.it> wrote:
> > The ecryptfs_find_auth_tok_for_sig() call is moved before the
> > mutex_lock(s->tfm_mutex) instruction in order to avoid possible deadlocks
> > that may occur by holding the lock on the two semaphores 'key->sem' and
> > 's->tfm_mutex' in reverse order.
> > 
> > Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> > ---
> >  fs/ecryptfs/keystore.c |   42 +++++++++++++++++++++++-------------------
> >  1 files changed, 23 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> > index e35d745..d066217 100644
> > --- a/fs/ecryptfs/keystore.c
> > +++ b/fs/ecryptfs/keystore.c
> > @@ -538,6 +538,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
> >  			     char *filename, size_t filename_size)
> >  {
> >  	struct ecryptfs_write_tag_70_packet_silly_stack *s;
> > +	struct ecryptfs_auth_tok *auth_tok;
> 
> Why declare a new ecryptfs_auth_tok struct pointer here? The idea behind
> the ecryptfs_write_tag_70_packet_silly_stack struct is to keep stack
> size at a minimum. Since it already has s->auth_tok, I don't see why we
> would need to declare a new one.
> 

Hi Tyler

i did this because i was thinking that 'tfm_mutex' is protecting
the 'auth_tok' field of the ecryptfs_parse_tag_70_packet_silly_stack
structure. Sorry, my mistake.

Thanks

Roberto


> >  	struct key *auth_tok_key = NULL;
> >  	int rc = 0;
> > 
> > @@ -550,6 +551,16 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
> >  	}
> >  	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> >  	(*packet_size) = 0;
> > +	rc = ecryptfs_find_auth_tok_for_sig(
> > +		&auth_tok_key,
> > +		&auth_tok, mount_crypt_stat,
> > +		mount_crypt_stat->global_default_fnek_sig);
> > +	if (rc) {
> > +		printk(KERN_ERR "%s: Error attempting to find auth tok for "
> > +		       "fnek sig [%s]; rc = [%d]\n", __func__,
> > +		       mount_crypt_stat->global_default_fnek_sig, rc);
> > +		goto out;
> > +	}
> >  	rc = ecryptfs_get_tfm_and_mutex_for_cipher_name(
> >  		&s->desc.tfm,
> >  		&s->tfm_mutex, mount_crypt_stat->global_default_fn_cipher_name);
> > @@ -635,16 +646,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
> >  		goto out_free_unlock;
> >  	}
> >  	dest[s->i++] = s->cipher_code;
> > -	rc = ecryptfs_find_auth_tok_for_sig(
> > -		&auth_tok_key,
> > -		&s->auth_tok, mount_crypt_stat,
> > -		mount_crypt_stat->global_default_fnek_sig);
> > -	if (rc) {
> > -		printk(KERN_ERR "%s: Error attempting to find auth tok for "
> > -		       "fnek sig [%s]; rc = [%d]\n", __func__,
> > -		       mount_crypt_stat->global_default_fnek_sig, rc);
> > -		goto out_free_unlock;
> > -	}
> > +	s->auth_tok = auth_tok;
> >  	/* TODO: Support other key modules than passphrase for
> >  	 * filename encryption */
> >  	if (s->auth_tok->token_type != ECRYPTFS_PASSWORD) {
> > @@ -831,6 +833,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
> >  			     char *data, size_t max_packet_size)
> >  {
> >  	struct ecryptfs_parse_tag_70_packet_silly_stack *s;
> > +	struct ecryptfs_auth_tok *auth_tok;
> 
> Same here as above.
> 
> Tyler
> 
> >  	struct key *auth_tok_key = NULL;
> >  	int rc = 0;
> > 
> > @@ -898,6 +901,15 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
> >  		       __func__, s->cipher_code);
> >  		goto out;
> >  	}
> > +	rc = ecryptfs_find_auth_tok_for_sig(&auth_tok_key,
> > +					    &auth_tok, mount_crypt_stat,
> > +					    s->fnek_sig_hex);
> > +	if (rc) {
> > +		printk(KERN_ERR "%s: Error attempting to find auth tok for "
> > +		       "fnek sig [%s]; rc = [%d]\n", __func__, s->fnek_sig_hex,
> > +		       rc);
> > +		goto out;
> > +	}
> >  	rc = ecryptfs_get_tfm_and_mutex_for_cipher_name(&s->desc.tfm,
> >  							&s->tfm_mutex,
> >  							s->cipher_string);
> > @@ -944,15 +956,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
> >  	 * >= ECRYPTFS_MAX_IV_BYTES. */
> >  	memset(s->iv, 0, ECRYPTFS_MAX_IV_BYTES);
> >  	s->desc.info = s->iv;
> > -	rc = ecryptfs_find_auth_tok_for_sig(&auth_tok_key,
> > -					    &s->auth_tok, mount_crypt_stat,
> > -					    s->fnek_sig_hex);
> > -	if (rc) {
> > -		printk(KERN_ERR "%s: Error attempting to find auth tok for "
> > -		       "fnek sig [%s]; rc = [%d]\n", __func__, s->fnek_sig_hex,
> > -		       rc);
> > -		goto out_free_unlock;
> > -	}
> > +	s->auth_tok = auth_tok;
> >  	/* TODO: Support other key modules than passphrase for
> >  	 * filename encryption */
> >  	if (s->auth_tok->token_type != ECRYPTFS_PASSWORD) {
> 
> 
> 
