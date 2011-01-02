Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1ABStr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 13:49:47 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29342 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab1ABStk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 13:49:40 -0500
Date: Sun, 2 Jan 2011 19:49:38 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Malcolm Priestley <tvboxspy@gmail.com>
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATVH] media, dvb, IX2505V: Remember to free allocated memory
 in failure path (ix2505v_attach()).
In-Reply-To: <1293820435.29966.59.camel@tvboxspy>
Message-ID: <alpine.LNX.2.00.1101021948100.11481@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012310008070.32595@swampdragon.chaosbits.net>  <1293758374.10326.7.camel@tvboxspy>  <alpine.LNX.2.00.1012311541430.16655@swampdragon.chaosbits.net> <1293820435.29966.59.camel@tvboxspy>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Dec 2010, Malcolm Priestley wrote:

> On Fri, 2010-12-31 at 15:51 +0100, Jesper Juhl wrote:
> > On Fri, 31 Dec 2010, Malcolm Priestley wrote:
> > 
> > > On Fri, 2010-12-31 at 00:11 +0100, Jesper Juhl wrote:
> > > > Hi,
> > > > 
> > > > We may leak the storage allocated to 'state' in 
> > > > drivers/media/dvb/frontends/ix2505v.c::ix2505v_attach() on error.
> > > > This patch makes sure we free the allocated memory in the failure case.
> > > > 
> > > > 
> > > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > > > ---
> > > >  ix2505v.c |    1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > >   Compile tested only.
> > > > 
> > > > diff --git a/drivers/media/dvb/frontends/ix2505v.c b/drivers/media/dvb/frontends/ix2505v.c
> > > > index 55f2eba..fcb173d 100644
> > > > --- a/drivers/media/dvb/frontends/ix2505v.c
> > > > +++ b/drivers/media/dvb/frontends/ix2505v.c
> > > > @@ -293,6 +293,7 @@ struct dvb_frontend *ix2505v_attach(struct dvb_frontend *fe,
> > > >  		ret = ix2505v_read_status_reg(state);
> > > >  
> > > >  		if (ret & 0x80) {
> > > > +			kfree(state);
> > > >  			deb_i2c("%s: No IX2505V found\n", __func__);
> > > >  			goto error;
> > > >  		}
> > > > 
> > > Memory is freed in... 
> > > 
> > > error:
> > > 	ix2505v_release(fe);
> > > 	return NULL;
> > > 
> > > via...
> > > 
> > > static int ix2505v_release(struct dvb_frontend *fe)
> > > {
> > > 	struct ix2505v_state *state = fe->tuner_priv;
> > > 
> > > 	fe->tuner_priv = NULL;
> > > 	kfree(state);
> > > 
> > > 	return 0;
> > > }
> > > 
> > 
> > Except that 'state' has not been assigned to fe->tuner_priv at this 
> > point, so ix2505v_release() cannot free the memory that was just 
> > allocated with kzalloc().
> > 
> > 
> >   state is a local variable:
> >   		struct ix2505v_state *state = NULL;
> > 		...
> > 
> >   we allocate memory and assign it to 'state' here:
> >   		state = kzalloc(sizeof(struct ix2505v_state), GFP_KERNEL);
> >   		if (NULL == state)
> >   			return NULL;
> >   	
> >   		state->config = config;
> >   		state->i2c = i2c;
> >   	
> >   here 'state' is used, but not in a way that saves it anywhere:
> >   		if (state->config->tuner_write_only) {
> >   			if (fe->ops.i2c_gate_ctrl)
> >   				fe->ops.i2c_gate_ctrl(fe, 1);
> >   	
> >   this function call involves 'state' but it does not save it anywhere
> >   either:
> >   			ret = ix2505v_read_status_reg(state);
> >   	
> >   			if (ret & 0x80) {
> >   				deb_i2c("%s: No IX2505V found\n", __func__);
> >   so when we jump to error here 'state' still exists only as the local
> >   variable, it has not been assigned to anything else.
> >   				goto error;
> >   			}
> >   		...
> >   	error:
> >   there is no way this function call can free 'state' on this path since
> >   it has not been assigned to fe->tuner_priv. 
> >   		ix2505v_release(fe);
> >   The local variable state goes out of scope here and leaks the memory it
> >   points to:
> >   		return NULL;
> >   	}
> > 
> > Am I missing something?
> 
> Oh, Sorry, I see it now.
> 
> Now there is two options.
> 
> Either;
> 
> 1) Move fe->tuner_priv = state to below line 287, so it can be released
> by ix2505v_release and fe->tuner_priv returned to NULL;
> 
> 2) or not calling ix2505v_release changing line 314 to kfree(state).
> fe->tuner_priv will remain NULL through out.
> 
[...]

How about this?


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 ix2505v.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/frontends/ix2505v.c b/drivers/media/dvb/frontends/ix2505v.c
index 55f2eba..15806e5 100644
--- a/drivers/media/dvb/frontends/ix2505v.c
+++ b/drivers/media/dvb/frontends/ix2505v.c
@@ -271,7 +271,7 @@ struct dvb_frontend *ix2505v_attach(struct dvb_frontend *fe,
 				    const struct ix2505v_config *config,
 				    struct i2c_adapter *i2c)
 {
-	struct ix2505v_state *state = NULL;
+	struct ix2505v_state *state;
 	int ret;
 
 	if (NULL == config) {
@@ -285,6 +285,7 @@ struct dvb_frontend *ix2505v_attach(struct dvb_frontend *fe,
 
 	state->config = config;
 	state->i2c = i2c;
+	fe->tuner_priv = state;
 
 	if (state->config->tuner_write_only) {
 		if (fe->ops.i2c_gate_ctrl)
@@ -301,8 +302,6 @@ struct dvb_frontend *ix2505v_attach(struct dvb_frontend *fe,
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	fe->tuner_priv = state;
-
 	memcpy(&fe->ops.tuner_ops, &ix2505v_tuner_ops,
 		sizeof(struct dvb_tuner_ops));
 	deb_i2c("%s: initialization (%s addr=0x%02x) ok\n",



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

