Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab1GKMJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 08:09:21 -0400
Received: from ccserver2.unican.es ([130.206.5.101]:59887 "EHLO
	ccserver2.unican.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab1GKMJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 08:09:20 -0400
Message-ID: <4E1AE803.2030904@unican.es>
Date: Mon, 11 Jul 2011 14:09:39 +0200
From: Monica Puig-Pey <puigpeym@unican.es>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) 
	Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: How to use plist.h in the rt-path?
Content-Type: text/plain;
	charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [193.144.198.131]
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:E SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18252.007)
X-imss-scores: Clean:0.25000 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:1 M:2 S:2 R:2 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

As I told in previous posts in this list I'm developing drivers for the
linux-rt kernel version in Ubuntu 10.04, based on 2.6.31 with rt_preempt 
patch.

Currently I'm studying how to use priority lists (linux/plist.h) in a 
module. I read some pages from the Linux Kernel Development book to 
learn how linked list work in the kernel.

I made and easy example, shown below, trying to put three elements, with 
their priorities, in a plist_head.

Then, I had two problems:

* First error:

   An error is produced when using the MACROs:
     - PLIST_HEAD_INIT(head, _lock)
     - PLIST_NODE_INIT(node, __prio)

   it says :

        /home/monica/Escritorio/plists/priolist.c: In function 
'init_module':
        /home/monica/Escritorio/plists/priolist.c:67: error: expected 
expression before '.' token


   --> To solve this I used the functions:

          - static inline void plist_head_init(struct plist_head *head, 
struct spinlock *lock)

          - static inline void plist_node_init(struct plist_node *node, 
int prio)

   But I still have the problem with the MACRO




* Second error, problem using plist_add:

   It says:

    “WARNING: "plist_add" [/home/monica/Escritorio/plists/priolist.ko] 
undefined! ”

   I made the module GPL, I don't know what am I doing wrong.

Does anybody have an idea what is happening?

Thanks in advance for any help,

Cheers,

         Monica

CODE:

#include <linux/module.h>	
#include <linux/kernel.h>
#include <linux/ioport.h>
#include <linux/plist.h>
#include <linux/spinlock.h>


MODULE_LICENSE("GPL");

#define pid_miguel 1
#define fichero_miguel 1
#define prio_miguel 10


#define pid_monica 2
#define fichero_monica 1
#define prio_monica 30

#define pid_hector 3
#define fichero_hector 1
#define prio_hector 20



static DEFINE_SPINLOCK(lock);


struct misdatos
{
   int pid;
   int fichero;
   struct plist_node token_del_plist;
};


int init_module(void)
{


   struct plist_head mi_lista_de_datos;
   //struct spinlock lock;
   struct misdatos datos_miguel;
   struct misdatos datos_monica;
   struct misdatos datos_hector;

   struct misdatos *elemento_iterador;

   // Inicializo mi lista
   //PLIST_HEAD_INIT( mi_lista_de_datos, lock);
   plist_head_init( &mi_lista_de_datos, &lock);

   // Creo mis datos
   datos_miguel.pid = pid_miguel;
   datos_miguel.fichero = fichero_miguel;

   datos_monica.pid = pid_monica;
   datos_monica.fichero = fichero_monica;

   datos_hector.pid = pid_hector;
   datos_hector.fichero = fichero_hector;

   // Inicializamos los nodos CON LA PRIORIDAD
   //PLIST_NODE_INIT(datos_miguel.token_del_plist, prio_miguel);
   //PLIST_NODE_INIT(datos_monica.token_del_plist, prio_monica);
   //PLIST_NODE_INIT(datos_hector.token_del_plist, prio_hector);
   plist_node_init(&datos_miguel.token_del_plist, prio_miguel);
   plist_node_init(&datos_monica.token_del_plist, prio_monica);
   plist_node_init(&datos_hector.token_del_plist, prio_hector);


   // Los agnadimos
   plist_add(&(datos_miguel.token_del_plist), &mi_lista_de_datos);
   plist_add(&(datos_monica.token_del_plist), &mi_lista_de_datos);
   plist_add(&(datos_hector.token_del_plist), &mi_lista_de_datos);



   plist_for_each_entry(elemento_iterador, &mi_lista_de_datos, 
token_del_plist)
   {
       printk(KERN_INFO "El pid es : %d, con prioridad %d\n", 
elemento_iterador->pid, elemento_iterador->token_del_plist.prio);
   }
   return 0;
}

void cleanup_module(void)
{
printk(KERN_INFO "cleanup_module() called\n");

}




