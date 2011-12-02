Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1LBMco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:32:44 -0500
Received: from monge.univ-mlv.fr ([193.55.63.80]:58360 "EHLO monge.univ-mlv.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab1LBMcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:32:43 -0500
X-Greylist: delayed 755 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Dec 2011 07:32:43 EST
Message-ID: <4ED8C275.7020907@univ-mlv.fr>
Date: Fri, 02 Dec 2011 13:20:05 +0100
From: =?UTF-8?B?U8OpYmFzdGllbiBQYXVtaWVy?= 
	<sebastien.paumier@univ-mlv.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: mmap
Content-Type: multipart/mixed;
 boundary="------------070303090801080808020400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070303090801080808020400
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,
I have a question about mmap's behavior when one tries to map a file asking for 
a length greater than the actual file size. When I run the attached code on a 
100 bytes file, I have the following output:

(... file content followed by zeros...)
n=4096
write: Bad address

So, it seems that the actual memory area provided by mmap is one page large and 
not the requested length of filesize+10000. I guess that 'write' writes less 
than requested because it was interrupted by the SIGBUS signal. And my question is:

shouldn't mmap either complain about the requested length or provide an 
accessible area of the requested length, instead of silently failing ?

Best regards,
Sébastien Paumier

--------------070303090801080808020400
Content-Type: text/x-csrc;
 name="mmap.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mmap.c"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <signal.h>
#include <time.h>
#include <errno.h>

int main(int argc, char* argv[]){
if(argc != 2) {
	fprintf(stderr,"Usage: %s <file>\n",argv[0]);
	exit(1);
}
int fd = open(argv[argc-1],O_RDONLY);
if (fd==-1) {
	perror("open");
	return 1;
}
struct stat status;
if(-1 == fstat(fd,&status)){
	perror("fstat");
	return 1;
}
char* mem=(char*) mmap(NULL, status.st_size+10000, PROT_READ, MAP_PRIVATE,fd,0);
if(mem == MAP_FAILED){
	perror("mmap");
	return 1;
}
int n;
if ( -1 == (n=write(1,mem, status.st_size+10000))) {
	perror("write");
	return 1;
}
printf("\nn=%d\n",n);
if( -1 == (n=write(1,mem+n, status.st_size+10000-n))) {
	perror("write");
	return 1;
}
printf("\nn=%d\n",n);
return 0;
}

--------------070303090801080808020400--
