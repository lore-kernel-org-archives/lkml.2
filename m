Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab2CPNOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:14:30 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:18544 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756364Ab2CPNO2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:14:28 -0400
X-SpamScore: -20
X-BigFish: VS-20(zz9371I2174M542M1432N98dKzz1202hzzz2fh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC103.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: RE: [PATCH 1/3] Drivers: hv: Support the newly introduced KVP
 messages in the driver
Thread-Topic: [PATCH 1/3] Drivers: hv: Support the newly introduced KVP
 messages in the driver
Thread-Index: AQHNAxFj2bSMdsAqMU2FB56/x8PctJZsafoAgAAE4BCAABUeAIAAU50A
Date: Fri, 16 Mar 2012 13:14:07 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B76671F@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1331858893-775-1-git-send-email-kys@microsoft.com>
 <1331858925-827-1-git-send-email-kys@microsoft.com>
 <20120316054556.GH3163@mwanda>
 <6E21E5352C11B742B20C142EB499E0481B7666A2@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20120316071858.GH3220@mwanda>
In-Reply-To: <20120316071858.GH3220@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Friday, March 16, 2012 3:19 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> Alan Stern
> Subject: Re: [PATCH 1/3] Drivers: hv: Support the newly introduced KVP
> messages in the driver
> 
> On Fri, Mar 16, 2012 at 06:33:35AM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > > Sent: Friday, March 16, 2012 1:46 AM
> > > To: KY Srinivasan
> > > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; virtualization@lists.osdl.org;
> ohering@suse.com;
> > > Alan Stern
> > > Subject: Re: [PATCH 1/3] Drivers: hv: Support the newly introduced KVP
> > > messages in the driver
> > >
> > > On Thu, Mar 15, 2012 at 05:48:43PM -0700, K. Y. Srinivasan wrote:
> > > >  	/*
> > > >  	 * The windows host expects the key/value pair to be encoded
> > > >  	 * in utf16.
> > > >  	 */
> > > >  	keylen = utf8s_to_utf16s(key_name, strlen(key_name),
> > > UTF16_HOST_ENDIAN,
> > > > -				(wchar_t *) kvp_data->data.key,
> > > > +				(wchar_t *) kvp_data->key,
> > > >  				HV_KVP_EXCHANGE_MAX_KEY_SIZE / 2);
> > > > -	kvp_data->data.key_size = 2*(keylen + 1); /* utf16 encoding */
> > > > +	kvp_data->key_size = 2*(keylen + 1); /* utf16 encoding */
> > > > +
> > >
> > > I feel like a jerk for asking this, but is the output length correct
> > > here?  It seems like we could go over again.  Also utf8s_to_utf16s()
> > > can return negative error codes, why do we ignore those?
> >
> > We are returning the strings back to the host here. There are checks elsewhere
> > in the code to ensure that all strings we return to the host can be
> accommodated
> > in the available space. For the most part these are strings that the host gave us
> in the
> > first place that have already been validated.  Furthermore, there are checks on
> the
> > host side to ensure that the returned size parameters are consistent with the
> protocol
> > definitions for the key value pair. For instance let us say somehow we got into a
> > situation where the converted utf16 string occupied the entire MAX sized array
> > without any room for the terminating character and we set the length
> parameter
> > to 2 more than the MAX value as this code would do. The host would simply
> discard the
> > message as an illegal message. This would be more appropriate than sending a
> > truncated key or value.
> >
> 
> Uh...  Looking at it again, this code is clearly off by one.  If
> we're not going to hit the limit, then we're not going to truncate,
> so that's not a concern.  Let's just use the correct limit here.

Dan,
I am trying to understand your concern here:
You will agree with me that the current code does not overflow the 
buffer since the output is limited to MAX bytes and that is how 
big the output buffer is sized. Now, as I pointed out earlier, if the
string to be converted were to fully occupy the MAX bytes or even be
larger than MAX bytes (no buffer overflow here since we limit the
conversion to MAX bytes), we will get a malformed packet that will be
sent to the host since the size field of the message would exceed
the protocol specified size limit. I was merely pointing out that in
this case, I would rather have the host reject the message than send
a truncated Key/Value string (if we were to ever get invalid key or
value strings). 

> 
> The problem is that off-by-ones tend to reproduce by copy and paste.
> It's best to never introduce any, even harmless ones.
> 
> Either that or add a comment.  /* Don't care about wrong limitter
> because we trust the input. */.
> 
All I am saying if we have an invalid string we will (a) ensure that we don't overflow
the output buffer and (b) we will generate a malformed packet as we should since
the string we are handling is not valid. Furthermore, I am suggesting that it is better
to have a malformed packet in this case than to have 

> > With regards to the negative values, negative values indicate a failure of some
> sort
> > in the conversion. Since the host is the recipient here, host will correctly deal
> with the
> > transaction by discarding the tuple.
> 
> I'm not super familiar with this subsystem.  Where can I find code
> for rejecting bad transactions?  It seems like an easy thing to
> handle the error in both places.  It makes auditing the code a lot
> simpler.

The host here is a windows host and the protocol verification engine there
will reject a mal-formed message. Having said this, what you are 
proposing is reasonable, I will re-send the patches.

Regards,

K. Y





