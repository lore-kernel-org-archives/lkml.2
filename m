Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0FWPAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:00:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64663 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0FWPAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:00:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=P+W13ofzlZCymoCEvXiK1qFiqEXR7kfdfTyOdfdNnH1ziSKkpNDXuEH6/r3998sN35
         tWqjYRkw5yMc3oYA0nfDMSXnbiJ8I2Hromg08d9sGKEc+bsKh3qG6NFQPoyieFTB6His
         T2FRx7n2sxjUvut+cTfhnZM5e8vw/ylimkWt4=
Message-ID: <4C221F0E.8070502@ring3k.org>
Date: Wed, 23 Jun 2010 23:49:50 +0900
From: Mike McCormack <mikem@ring3k.org>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: oleg@redhat.com, kosaki.motohiro@jp.fujitsu.com, serue@us.ibm.com,
       jmorris@namei.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: Add complete process group list
References: <4C20D1AE.5000205@ring3k.org> <20100622153757.dcb6bda9.akpm@linux-foundation.org>
In-Reply-To: <20100622153757.dcb6bda9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>> This feature might be useful for a server listening on a unix domain pipe
>>  to determine the list of groups that a client process is in from its pid.
> 
> "might be"?

Well, "would be" :-)

> It would be useful to hear a bit more about usage scenarios, why this
> is needed, etc - some hard info which would justify permanent extension
> of the kernel->userspace API.  How does this get used, why is it
> needed, what are the alternatives, etc.

This will be used in a device with groups permissions checked in userspace.

Say you have a process called "telephony-server", and it talks to a number 
of client processes with different privilege levels via a unix domain socket.

telephony-server might be able do things which should have different privilege 
levels, like send SMS messages, make phone calls, download firmware to a 3G 
modem, etc.  The client processes would be members of groups reflecting
each privilege.  Depending on the number of similar servers in the system, 
and how fine-grained the privileges are, there might be lots of groups (>32).

telephony-server should be able to allow or deny requests depending on whether
an application is a member of the correct group or not. 

unix sockets can pass credentials, but currently I can only see struct ucred 
(pid, uid and gid) being passed.  Using the pid, /proc/pid/status can be read 
for a list of groups, but it only lists up to 32 groups.

Ways I can see to get the groups for a unix socket peer from it's pid all 
mostly require some kernel modification:

* modify kernel to list all groups in /proc/<pid>/status 
    - very long lines become possible in status file
    - no way to know whether you're using an old kernel with 32 group limit
       or new kernel and pid only has 32 groups

* modify kernel to add /proc/<pid>/groups
    - more kernel-userland interface

* implement LOCAL_CREDS for unix domain sockets in Linux
    - work

* limit number of groups to 32
    - limit is imposed by /proc code

* create multiple unix domian sockets per privilege with group r/w only
    - seems like trouble


What do you think?

thanks,

Mike

