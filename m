Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0FZP6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 11:58:15 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:55694 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0FZP6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 11:58:13 -0400
X-Authority-Analysis: v=1.1 cv=RJh5qLNcouNXRoa2xeUuD5+cYELFcZRJb8XCZWNbBzY= c=1 sm=0 a=v6q0ed96Jx4A:10 a=hO-oPbc3tlwA:10 a=kj9zAlcOel0A:10 a=ld/erqUjW76FpBUqCqkKeA==:17 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8 a=p3T0RCafYPqiqG5joB4A:9 a=XSQYUfZpPVnNs04Ey16olpjt83sA:4 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=dowx1zmaLagA:10 a=ld/erqUjW76FpBUqCqkKeA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
Date: Sat, 26 Jun 2010 11:58:10 -0400
From: Jeff Layton <jlayton@samba.org>
To: Andrew Hendry <andrew.hendry@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: 2.6.34-rc3 BUG: unable to handle kernel NULL pointer
 dereference  at 0000000000000048 cifs_show_options
Message-ID: <20100626115810.532913f5@tlielax.poochiereds.net>
In-Reply-To: <AANLkTikXz-zW3_nh0k941BPHWLJMN630l2R5sPoc35kC@mail.gmail.com>
References: <AANLkTilhTrEBYZd4HxeXQk8B6-yV8rCJ2C0jXsEREgIR@mail.gmail.com>
	<AANLkTimTmPEG-8gDKu7Xj8--LrXsF9oe-afbm0X_QHsX@mail.gmail.com>
	<20100626075125.3d1711ff@tlielax.poochiereds.net>
	<AANLkTikXz-zW3_nh0k941BPHWLJMN630l2R5sPoc35kC@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jun 2010 22:22:00 +1000
Andrew Hendry <andrew.hendry@gmail.com> wrote:

> I have turned on cifs debug to try to catch it if happens again.
> 
> (gdb) list *(cifs_show_options+0xf9)
> 0x309 is in cifs_show_options (fs/cifs/cifsfs.c:336).
> 331	static void
> 332	cifs_show_address(struct seq_file *s, struct TCP_Server_Info *server)
> 333	{
> 334		seq_printf(s, ",addr=");
> 335	
> 336		switch (server->addr.sockAddr.sin_family) {
> 337		case AF_INET:
> 338			seq_printf(s, "%pI4", &server->addr.sockAddr.sin_addr.s_addr);
> 339			break;
> 340		case AF_INET6:
> 
> 
> 
> 

Thanks, that helps. It looks like the "server" pointer in that function
was NULL or something close to it. Those should be properly refcounted
nowadays and that hasn't changed in quite a while. This function only
gets called from one place -- cifs_show_options. So something was
reading /proc/self/mountinfo and this pointer got zeroed out. Maybe
this raced with an unmount and the memory was recycled? Doesn't seem
like that ought to be possible though (I think vfsmount references are
held for each of these calls).

-- 
Jeff Layton <jlayton@samba.org>
