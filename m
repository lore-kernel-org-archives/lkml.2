Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1GUGyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 02:54:51 -0400
Received: from webmail1.b-one.net ([195.47.247.29]:6664 "EHLO webmail1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab1GUGys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 02:54:48 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jul 2011 02:54:48 EDT
Message-ID: <c2b2191a22eab7f6127d5ea1d519bee1.squirrel@webmail01.one.com>
Date: Thu, 21 Jul 2011 08:47:44 +0200
Subject: Possible bug in inotify api
From: Morten Winkler =?iso-8859-1?Q?J=F8rgensen?= <morten@winkler.dk>
To: linux-kernel@vger.kernel.org
Reply-To: morten@winkler.dk
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20110721084744_94144"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20110721084744_94144
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

To whom it might concern

I'd like to report a possible malfunction of the inotify api and check if
this issue has been reported.
If this is not the proper place to do so, please let me know. I have
searched the archives and the web and found similar reportings but none
the same.

The observed behavior is when calling inotify_remove_watch. Now and then
it returns error 22, INVALID_ARGUMENT, even though the watchdesriptor
ought to be valid. I've seen that people complain about this behavior on
the dovecot mailing list but nobody seems to have suggested a fix.

I've attached a small program that I use to reproduce the behavior.
The program watches /tmp and whenever it's notified about a directory
created in /tmp, my program adds a watch for that directory as well.

The program is a C++ program (as I will need the inotify functionality in
a C++ program, but the behavior is the same in a pure C implementation)
and to reproduce I do the following:

* g++ main.cpp
* ./a.out

In a shell I go to /tmp and run
* for i in `seq 1 5000`; do mkdir D-$i; done; for i in `seq 1 5000`; do
rmdir D-$i; done

This makes my testprogram output the wd's created and and the wd's my
program tries to remove. I've never seen the program successfully remove
all 5000 watch descriptors and I've seen inotify_rm_watch fail after 0
removes and after approx 2000 removes and anything in between.

I'm running kernel 2.6.23-5 from the Debian repositories.

If what I've written is totally nonsense, if it is expected behavior or if
I've done anything wrong, please let me know. Also, if I can do anything
further to investigate the misbehavior also, please let me know.

Best and thanks in advance,
   Morten

Attached: C++ program used to reproduce the behavior.

------=_20110721084744_94144
Content-Type: text/x-c++src; name="main.cpp"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="main.cpp"

#include <sys/inotify.h>
#include <sys/syscall.h>

// Use this if syscalls not defined
#ifndef __NR_inotify_init
#include <sys/inotify-syscalls.h>
#endif // __NR_inotify_init


#include <stdio.h>
#include <unistd.h>
#include <map>
#include <string>

using namespace std;

typedef map<string, int> StrIntMap;
typedef pair<string, int> StrIntPair;

typedef map<int, string> IntStrMap;
typedef pair<int, string> IntStrPair;

StrIntMap pathsToWds;
IntStrMap wdsToPaths;

int fd;

int AddWatch(const string &path)
{
    int wd = inotify_add_watch( fd, (char*)(path.c_str()), IN_CREATE | IN_DELETE | IN_MODIFY );
    pathsToWds.insert(StrIntPair(path, wd));
    wdsToPaths.insert(IntStrPair(wd, path));
    printf("Adds %s as wd %d. Has %d watches\n", path.c_str(), wd, pathsToWds.size());
    return wd;
}

void RemoveWatch(const string &path)
{
    int wd = pathsToWds[path];
    pathsToWds.erase(path);
    wdsToPaths.erase(wd);
    printf("Removes %s as wd %d. Has %d watches\n", path.c_str(), wd, pathsToWds.size());
    
    if( inotify_rm_watch(fd, wd) != -1)
    {
        throw string("No no no...");
    }
}


void RemoveWatch(int wd)
{
    RemoveWatch(wdsToPaths[wd]);
}


int main( ) 
{
  
    try
    {
    
    int EVENT_SIZE =  sizeof (struct inotify_event) ;
    int EVENT_BUF_LEN =  ( 1024 * ( EVENT_SIZE + 16 ) );
    int length, i = 0;
    char buffer[EVENT_BUF_LEN];

    /*creating the INOTIFY instance*/
    fd = inotify_init();

    /*checking for error*/
    if ( fd < 0 ) {
    //    perror( "inotify_init" );
    }

    /*adding the “/tmp” directory into watch list. Here, the suggestion is to validate the existence of the directory before adding into monitoring list.*/
    string bd = "/tmp";
    AddWatch(bd);



    while(1) {
        length = 0; 
        i = 0;
        length = read( fd, buffer, EVENT_BUF_LEN ); 
        /*checking for error*/
        if ( length < 0 ) {
            perror( "read" );
        }  

        /*actually read return the list of change events happens. Here, read the change event one by one and process it accordingly.*/
        while ( i < length ) {     
      
            struct inotify_event *event = ( struct inotify_event * ) &buffer[ i ];     
            
            if ( event->len ) {

                string parentdir;
                parentdir = wdsToPaths[event->wd];

                if ( event->mask & IN_CREATE ) {
                    if ( event->mask & IN_ISDIR ) {
                        printf( "New directory %s created in %s.\n", event->name, parentdir.c_str());
                        
                        AddWatch(parentdir+"/"+event->name);
                    }
                    else {
                        printf( "New file %s created in %s.\n", event->name, parentdir.c_str());
                    }
                }
                else if ( event->mask & IN_DELETE ) {
                    if ( event->mask & IN_ISDIR ) {
                        printf( "Directory %s deleted in %s.\n", event->name, parentdir.c_str() );
                        RemoveWatch(parentdir+"/"+event->name);
                    }
                    else {
                        printf( "File %s deleted in %s.\n", event->name, parentdir.c_str());
                    }
                }
                else if ( event->mask & IN_MODIFY)
                {
                    if ( event->mask & IN_ISDIR ) {
                        printf( "Directory %s modified in %s.\n", event->name, parentdir.c_str());
                    }
                    else {
                        printf( "File %s modified in %s.\n", event->name, parentdir.c_str());
                    }
                }
            }
            i += EVENT_SIZE + event->len;
        }
    }
    /*removing the “/tmp” directory from the watch list.*/
    

    /*closing the INOTIFY instance*/
    close( fd );
    }
    catch(string s)
    {
        printf("Caught: %s\n", s.c_str());
    }
}
------=_20110721084744_94144--


