Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab2JOXes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:34:48 -0400
Received: from granite.fifsource.com ([173.255.216.206]:46005 "EHLO
	granite.fifsource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab2JOXee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:34:34 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Oct 2012 19:34:34 EDT
Message-ID: <1350343478.4523.7.camel@air.home.fifi.org>
Subject: Re: Write is not atomic?
From: Philippe Troin <phil@fifi.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Juliusz Chroboczek <jch@pps.jussieu.fr>, linux-kernel@vger.kernel.org
Date: Mon, 15 Oct 2012 16:24:38 -0700
In-Reply-To: <20121015231302.GF2739@dastard>
References: <7i391fto34.fsf@lanthane.pps.jussieu.fr>
	 <20121015231302.GF2739@dastard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-16 at 10:13 +1100, Dave Chinner wrote:
> On Mon, Oct 15, 2012 at 11:36:15PM +0200, Juliusz Chroboczek wrote:
> > Hi,
> > 
> > The Linux manual page for write(2) says:
> > 
> >     The adjustment of the file offset and the write operation are
> >     performed as an atomic step.
> 
> That's wrong. The file offset update is not synchronised at all with
> the write, and for a shared fd the update will race.

That's what O_APPEND or pread/pwrite are for.

> > This is apparently an extension to POSIX, which says
> > 
> >     This volume of IEEE Std 1003.1-2001 does not specify behavior of
> >     concurrent writes to a file from multiple processes. Applications
> >     should use some form of concurrency control.
> 
> This is how Linux behaves.
> 
> > The following fragment of code
> > 
> >     int fd;
> >     fd = open("exemple", O_CREAT | O_WRONLY | O_TRUNC, 0666);
> >     fork();
> >     write(fd, "Ouille", 6);
> >     close(fd);

can be replaced with:

        int fd;
        fd = open("exemple", O_CREAT | O_WRONLY | O_TRUNC | O_APPEND, 0666);
        fork();
        write(fd, "Ouille", 6);
        close(fd);

or:

        int fd;
    fd = open("exemple", O_CREAT | O_WRONLY | O_TRUNC, 0666);
    pid_t pid = fork();
    pwrite(fd, "Ouille", 6, strlen("Ouille")*(pid == 0));
    close(fd);

(both code fragments untested)

Phil.

