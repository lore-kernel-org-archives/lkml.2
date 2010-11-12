Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab0KLRmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:42:14 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42193 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab0KLRmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:42:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l+tfjDvi9P+8fTKJYTz8PkwEt44fce5SR/M77fUECX5z4QjkXHdCuRq6ca7hRMqGqJ
         koaZ9tIzUq8sHqoZT2cpwGym5XPv0KyMh2f08h+9rgco5lspA+AD8BT+005U7HtP5kqx
         3Kd47JxQW2cI72wEwDkK9ir8VnF3gRhcuiaUY=
Date: Fri, 12 Nov 2010 20:42:03 +0300
From: Vasiliy Kulikov <segooon@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-janitors@vger.kernel.org,
        =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
        Joe Perches <joe@perches.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: vsprintf: fix invalid arg check
Message-ID: <20101112174203.GA10430@albatros>
References: <1289421490-23950-1-git-send-email-segooon@gmail.com>
 <20101110130834.02496b48.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1011101335410.7756@chino.kir.corp.google.com>
 <20101111083408.GA3471@albatros>
 <alpine.DEB.2.00.1011111224161.25829@chino.kir.corp.google.com>
 <20101111210251.GA26283@albatros>
 <alpine.DEB.2.00.1011111319110.25829@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011111319110.25829@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 13:34 -0800, David Rientjes wrote:
> On Fri, 12 Nov 2010, Vasiliy Kulikov wrote:
> > OK, if the main reason here is return value type, then the correct
> > handling should be:
> > 
> > 	/* Reject out-of-range values early.  Large positive sizes are
> > 	   used for unknown buffer sizes. */
> > -	if (WARN_ON_ONCE((int) size < 0))
> > +	if (WARN_ON_ONCE(size > INT_MAX)
> > 		return 0;
> > 
> > This should catch all underflows and too big integers.
> > 
> 
> That is equivalent since size_t is always unsigned;

Not equivalent:

void test_size(size_t size)
{
    char buffer[128];
    sprintf(buffer, "size %lx is BAD", size);
    snprintf(buffer, size, "size %lx is OK", size);
    pr_info("%s\n", buffer);
    if (size > INT_MAX)
        pr_info("%lx is catched by (size) > INT_MAX", size);
}

static int init(void) {
        test_size(0x7FFFFFFF);
        test_size(0x80000000);
        test_size(0x80000001);
        test_size(0xFFFFFFFF);
        test_size(0x100000000);
        test_size(0x100000001);
        test_size(0x17fffffff);
        test_size(0x180000000);
        test_size(0x180000001);

        return 0;
}


Output on x86_64:

[12486.542047] size 7fffffff is OK
[12486.542051] size 80000000 is BAD
[12486.542053] 80000000 is catched by (size) > INT_MAX
[12486.542055] size 80000001 is BAD
[12486.542057] 80000001 is catched by (size) > INT_MAX
[12486.542059] size ffffffff is BAD
[12486.542061] ffffffff is catched by (size) > INT_MAX
[12486.542063] size 100000000 is OK
[12486.542065] 100000000 is catched by (size) > INT_MAX
[12486.542067] size 100000001 is OK
[12486.542069] 100000001 is catched by (size) > INT_MAX
[12486.542071] size 17fffffff is OK
[12486.542073] 17fffffff is catched by (size) > INT_MAX
[12486.542075] size 180000000 is BAD
[12486.542077] 180000000 is catched by (size) > INT_MAX
[12486.542079] size 180000001 is BAD
[12486.542081] 180000001 is catched by (size) > INT_MAX


-- 
Vasiliy
